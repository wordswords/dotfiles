#!/bin/bash
## Sets up configuration

# Load in status message printing functions
. ./deploy-common.sh

report_progress 1 'Deploying dotfiles: Part 1'

report_progress 2 'Backing up existing dotfiles to ~/.olddotfiles..'
rm -rf ~/.olddotfiles
mkdir -p ~/.olddotfiles
cp -R ~/.vim ~/.olddotfiles/
cp ~/.vimrc ~/.olddotfiles/.vimrc
cp ~/.bash_profile ~/.olddotfiles/.bash_profile
cp ~/.zshrc* ~/.olddotfiles/
cp -R ~/.oh-my-zsh ~/.olddotfiles/.oh-my-zsh

report_progress 2 'Removing existing zsh config..'
rm -rf ~/.zshrc
rm -rf ~/.oh-my-zsh

report_progress 2 'Installing oh-my-zsh..'
cd ~ || exit 1
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

