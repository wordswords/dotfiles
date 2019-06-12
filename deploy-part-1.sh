#!/bin/bash

# backup
rm -rf ~/.olddotfiles
mkdir -p ~/.olddotfiles
cp -R ~/.vim ~/.olddotfiles/
cp ~/.vimrc ~/.olddotfiles/.vimrc
cp ~/.bash_profile ~/.olddotfiles/.bash_profile
cp ~/.zshrc* ~/.olddotfiles/
cp -R ~/.oh-my-zsh ~/.olddotfiles/.oh-my-zsh

# remove

rm -rf ~/.zshrc
rm -rf ~/.oh-my-zsh
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bash_profile
rm -rf ~/bin

# Install oh-my-zsh

cd ~ || exit 1
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"


