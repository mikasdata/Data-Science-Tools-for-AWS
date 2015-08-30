#!/bin/bash

# Bash script to install data science tools on a
# 64-bit Ubuntu Server 14.04 LTS (HVM) running on an Amazon Web Services EC2

# Part 01 system update and reboot

echo ""
echo "Update the system"

# System update
sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

# Install dependencies
sudo apt-get install tk8.5 tcl8.5 libatlas-base-dev libfreetype6-dev

echo ""
echo "Install git"

# Install git
sudo apt-get install -y git github-backup

echo ""
echo "System reboot"

# Reboot the system
sudo reboot
