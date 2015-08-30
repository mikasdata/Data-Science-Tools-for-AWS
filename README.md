# Data-Science-Tools-for-AWS
Scripts to install data science tools on a 64-bit Ubuntu Server 14.04 LTS (HVM) running on an Amazon Web Services EC2.

These scripts install R, RStudio, Shiny-server, Python and IPython notebooks on an AWS EC2 Ubuntu instance.

Run first

```
./InstallDSToolsUpdate.sh
```

to update the system and reboot. This first step might not be necessary for all setups.

To install R, RStudio and Shiny-server, run

```
sudo su
./InstallDSToolsR.sh
```

The script will also install the R packages defined in `InstallPackages.R`.

Finally install Python and Ipython notebooks by running

```
./InstallDSToolsPython.sh
```

This last script utilizes the `ipythonPassword.py` program.


