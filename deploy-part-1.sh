#!/usr/bin/env bash
## Sets up configuration

set -e

# Load in status message printing functions
. ./deploy-common.sh

baseos=$(get_os)

report_progress 1 'Deploying dotfiles: Part 1'

report_progress 2 'Backing up existing dotfiles to ~/.olddotfiles..'
rm -rf ~/.olddotfiles
mkdir -p ~/.olddotfiles

cp -RL ~/.vim ~/.olddotfiles/.vim || echo "INFO: Could not backup .vim dir, does it exist?"
cp -RL ~/.zsh* ~/.olddotfiles/ || echo "INFO: Could not backup .zsh* dirs, do they exist?"
cp -RL ~/.oh-my-zsh ~/.olddotfiles/ || echo "INFO: Could not backup .oh-my-zsh directory, does it exist?"
cp -L ~/.bash_aliases ~/.olddotfiles/.bash_aliases || echo "INFO: Could not backup .bash_aliases, does it exist?"
cp -L ~/.bash_profile ~/.olddotfiles/.bash_profile || echo "INFO: Could not backup .bash_profile, does it exist?"
cp -L ~/.vimrc ~/.olddotfiles/.vimrc || echo "INFO: Could not backup .vimrc, does it exist?"

report_progress 2 'Removing existing zsh config..'
rm -rf ~/.zshrc
rm -rf ~/.oh-my-zsh

report_progress 2 'Installing oh-my-zsh..'
cd ~ || exit 1
sh -c "$(wget --no-check-certificate https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

