#!/usr/bin/env bash
## Sets up configuration

# Load in status message printing functions
. ./deploy-common.sh

baseos=$(get_os)

report_progress 1 'Deploying dotfiles: Part 1'

if [ "$baseos" = "osx" ]; then
  report_progress 2 'Configuring OSX and brew install packages..'
  ./configure-osx.sh
fi

report_progress 2 'Backing up existing dotfiles to ~/.olddotfiles..'
rm -rf ~/.olddotfiles
mkdir -p ~/.olddotfiles
cp ~/.vimrc ~/.olddotfiles/.vimrc
cp ~/.bash_profile ~/.olddotfiles/.bash_profile
cp ~/.zshrc* ~/.olddotfiles/

if [ "$baseos" = "osx" ]; then
  /usr/bin/env gcp -R ~/.oh-my-zsh ~/.olddotfiles/.oh-my-zsh
  /usr/bin/env gcp -R ~/.vim ~/.olddotfiles/
else
  cp -R ~/.oh-my-zsh ~/.olddotfiles/.oh-my-zsh
  cp -R ~/.vim ~/.olddotfiles/
fi

report_progress 2 'Removing existing zsh config..'
rm -rf ~/.zshrc
rm -rf ~/.oh-my-zsh

report_progress 2 'Installing oh-my-zsh..'
cd ~ || exit 1
sh -c "$(wget --no-check-certificate https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

