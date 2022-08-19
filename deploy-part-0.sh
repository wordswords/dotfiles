#!/bin/bash

set -e

echo "We will now attempt to install the preqs under Ubuntu-compatible systems."

sudo apt install vim git python3 python3-pip openjdk-18-jdk zsh ecryptfs-utils exuberant-ctags net-tools fortune-mod fortunes-ubuntu-server ripgrep

echo "We will now attempt to enable automated unattended-upgrades"
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades




