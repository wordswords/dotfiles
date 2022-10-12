#!/bin/bash
# vim: spell set nowrap

set -e
source ./deploy-common.sh

report_heading 'Deploy Prerequisites: Part 0'

report_progress 'We will now attempt to install the preqs under Ubuntu-compatible systems.'
# fresh start
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y
# vim9
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt update -y && sudo apt upgrade -y
sudo apt upgrade vim -y
# speedtest-cli
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest
# git
sudo apt install git -y
# Python 3 used for vim plugins
sudo apt install python3 -y
sudo apt install python3-pip -y
# Java open jdk, used for LanguageTool checker
sudo apt install default-jdk -y
# zsh the best shell (so far)
sudo apt install zsh -y
# Used for encrypted .secure dir
sudo apt install ecryptfs-utils -y
# Ctags used for fugative
sudo apt install exuberant-ctags -y
# net-tools used for?
sudo apt install net-tools -y
# Install fortune cookie for shell login
sudo apt install fortune-mod -y
# Ripgrep used for :CocSearch
sudo apt install ripgrep -y
# tree is very useful for showing directory structures'
sudo apt install tree -y
report_done

report_progress 'We will now attempt to enable automated unattended-upgrades'
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
report_done
