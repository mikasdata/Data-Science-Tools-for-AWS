#!/bin/bash

# Bash script to install data science tools on a
# 64-bit Ubuntu Server 14.04 LTS (HVM) running on an Amazon Web Services EC2

# Part 02 install R, RStudio and Shiny-server

# Remember before running the script:
# chmod u+x InstallDSToolsR.sh
# sudo su
# To run the script:
# ./InstallDSToolsR.sh

echo ""
echo "This script will install and configure the following data science tools:"
echo " R"
echo " RStudio-server"
echo " Python"
echo " IPython (with notebook server)"
echo " Shiny-server"

echo ""
echo "Create a group and a user with a password for RStudio-server to limit security risk."

read -p "RStudio user group [rstudio_users]: " rstudioGroup
rstudioGroup=${rstudioGroup:-rstudio_users}
read -p "Create RStudio user: " rstudioUser
read -s -p "Password for $rstudioUser: " rstudioPassword
echo ""
read -s -p "Confirm password: " rstudioPassword_confirm
if [ "$rstudioPassword" != "$rstudioPassword_confirm" ]
	then
		echo ""
		echo "RStudio-server user passwords did not match! Please re-run script."
		exit
fi

echo ""

sudo groupadd $rstudioGroup
sudo useradd -m -N $rstudioUser
echo "$rstudioUser:$rstudioPassword" | sudo chpasswd
sudo chmod -R +u+r+w /home/$rstudioUser
# sudo chmod -R +u+r+w /home/%rstudioUser

echo ""
sudo usermod -G $rstudioGroup $rstudioUser
echo "New user group $rstudioGroup created. Add users to this group for access to RStudio-server."
echo ""

echo ""
echo "Install R"
echo ""

# Set debsource:

debsource='deb http://cran.uni-muenster.de/bin/linux/ubuntu trusty/'

# Choose the R version if necessary:
rversion='3.2.1-4trusty0'

# Remove old R
sudo apt-get remove r-base r-base-core r-recommended r-base-dev

echo ${debsource} >> /etc/apt/sources.list

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update

echo "\n\nFinished update, installing R...\n\n"

# Install with R version if necessary
sudo apt-get -y --force-yes install r-base=${rversion} r-recommended=${rversion} r-base-dev=${rversion}
sudo apt-get -y --force-yes install r-base-core=${rversion}

# Install without R version
# sudo apt-get -y --force-yes install r-base r-recommended r-base-dev
# sudo apt-get -y --force-yes install r-base-core

echo ""
echo "Install RStudio-server"
echo ""

# Set the RStudio-server version:

rstudiover='0.99.473'

# Install a needed dependency for RStudio-server
sudo apt-get install libjpeg62

sudo wget http://download2.rstudio.org/rstudio-server-${rstudiover}-amd64.deb
sudo dpkg -i *.deb
sudo rm *.deb

echo ""
echo "Install Shiny-server"
echo ""

# Set the Shiny-server version:

shinyver='1.4.0.721'

# Install a needed dependency for Shiny-server
sudo apt-get install libssl0.9.8

sudo su - \
    -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-${shinyver}-amd64.deb
# Install gdebi for installing Shiny-server
# sudo apt-get install gdebi-core
# sudo gdebi shiny-server-${shinyver}-amd64.deb
sudo dpkg -i *.deb
rm *.deb

sudo mkdir /srv/shiny-server/examples
sudo cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/examples/

# Install R packages
sudo R CMD BATCH InstallPackages.R

exit