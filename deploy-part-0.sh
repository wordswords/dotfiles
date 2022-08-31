#!/bin/bash

set -e

echo "We will now attempt to install the preqs under Ubuntu-compatible systems."

sudo apt install vim git
# Python 3 used for vim plugins
sudo apt install python3
sudo apt install python3-pip
# Java open jdk, used for LanguageTool checker
sudo apt install default-jdk
# zsh the best shell (so far)
sudo apt install zsh
# Used for encrypted .secure dir
sudo apt install ecryptfs-utils
# Ctags used for fugative 
sudo apt install exuberant-ctags
# net-tools used for?
sudo apt install net-tools
# Install fortune cookie for shell login
sudo apt install fortune-mod
# Ubuntu CLI command fortunes
sudo apt install fortunes-ubuntu-server
# Ripgrep used for :CocSearch
sudo apt install ripgrep
# tree is very useful for showing directory structures'
sudo apt install tree

echo "We will now attempt to enable automated unattended-upgrades"
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades




