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

if [ "$baseos" = "osx" ]; then
  alias cp='/usr/bin/env gcp'
fi

cp -RL ~/.e ~/.olddotfiles/.e
cp -RL ~/.vim ~/.olddotfiles/.vim
cp -RL ~/.zsh* ~/.olddotfiles/
cp -RL ~/.oh_my_zsh ~/.olddotfiles/
cp -L ~/.bash_aliases ~/.olddotfiles/.bash_aliases
cp -L ~/.bash_profile ~/.olddotfiles/.bash_profile
cp -L ~/.vimrc ~/.olddotfiles/.vimrc

report_progress 2 'Removing existing zsh config..'
rm -rf ~/.zshrc
rm -rf ~/.oh-my-zsh

report_progress 2 'Installing oh-my-zsh..'
cd ~ || exit 1
sh -c "$(wget --no-check-certificate https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

