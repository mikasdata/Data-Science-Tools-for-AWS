#!/bin/bash

# Bash script to install data science tools on a
# 64-bit Ubuntu Server 14.04 LTS (HVM) running on an Amazon Web Services EC2

# Part 03 install Python and Ipython notebooks

echo ""
echo "This script will install and configure the following data science tools:"
echo " Python"
echo " IPython (with notebook server)"

echo ""
echo "Create a new IPython profile with a password to limit security risks."

read -p "Profile name for IPython server: " ipythonProfile
read -s -p "Password for $ipythonProfile: " ipythonPassword
echo ""
read -s -p "Confirm password: " ipythonPassword_confirm
if [ "$ipythonPassword" != "$ipythonPassword_confirm" ] 
	then
		echo ""
		echo "IPython profile passwords did not match! Please re-run script."
		exit
fi

echo ""
echo "Create a self-signed SSL key to encrypt password transmission in the browser."

pathpem="/home/ubuntu/.ssh/ipython_$ipythonProfile.pem"
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout $pathpem -out $pathpem

echo ""
echo "Install Python development and scientific support libraries"

# Install libraries
sudo apt-get install -y -qq python-pip python-dev python-scipy python-numpy python-matplotlib python-pandas python-nose python-sympy python-scikits.learn

echo ""
echo "Install Python setuptools"

# Install setuptools for Python
wget https://bootstrap.pypa.io/ez_setup.py -O - | sudo python

echo ""
echo "Install IPython support libraries"

# Install supporting Python libraries
cd ..
sudo easy_install Cython oct2py rpy2 azure

echo ""
echo "Install IPython"

# Remove the Ubuntu IPython and Install IPython
sudo apt-get remove ipython ipython-notebook
sudo apt-get install -y -qq ipython-notebook
sudo pip install "ipython[all]"

echo ""
echo "Creating IPython profile"

# Create a profile for the IPython server
sudo ipython /home/ubuntu/ipythonPassword.py $ipythonPassword
passwordfile="passwdhash.txt"
passwordhash=`cat $passwordfile`
sudo rm -f $passwordfile
ipython profile create $ipythonProfile
notebook_config="/home/ubuntu/.ipython/profile_$ipythonProfile/ipython_notebook_config.py"


# Append user settings to the config file
echo "c.IPKernelApp.pylab = 'inline' " | sudo tee -a $notebook_config
echo "c.NotebookApp.ip = '*' " | sudo tee -a $notebook_config
echo "c.NotebookApp.open_browser = False " | sudo tee -a $notebook_config
echo "c.NotebookApp.password = u'$passwordhash'" | sudo tee -a $notebook_config
echo "c.NotebookApp.port = 8888" | sudo tee -a $notebook_config
echo "c.NotebookApp.certfile = '$pathpem'" | sudo tee -a $notebook_config

# Clean up downloaded files
sudo rm -rf Downloads
sudo rm -f setuptools-18.2.zip

echo ""
echo "To connect securely add necessary SSH-tunnels."
echo "For example to connect to RStudio-server set"
echo "Source port: 8787 Destination: localhost:8787"
echo ""
echo "The RStudio-server is available at http://localhost:8787"
echo "Shiny-server is available at http://localhost:3838"
echo "To start the IPython notebook server type:" 
echo "sudo ipython notebook --no-browser --ip=localhost --port=8888 --profile=$ipythonProfile"

exit