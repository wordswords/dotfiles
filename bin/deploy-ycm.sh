#!/bin/bash

set -e
set -x

# Install Cmake 3.28.0
sudo apt-get install build-essential python3-dev libssl-dev
wget https://github.com/Kitware/CMake/releases/download/v3.28.0/cmake-3.28.0.tar.gz
tar xzf cmake-3.28.0.tar.gz
cd ./cmake-3.28.0
./bootstrap && make && sudo make install
cd -
rm -rf ./cmake-3.28.0

# Assumes node is already installed - Installs all other prereqs for YCM
sudo apt-get install -y mono-complete golang openjdk-17-jdk openjdk-17-jre

# Install YCM
rm -rf ~/.vim/bundle/YouCompleteMe/
git clone git@github.com:ycm-core/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
cd ~/.vim/bundle/YouCompleteMe/
git submodule update --init --recursive
python3 install.py --all
