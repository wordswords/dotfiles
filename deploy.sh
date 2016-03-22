#!/bin/bash

# backup
rm -rf ~/.olddotfiles
mkdir -p ~/.olddotfiles
cp -R ~/.vim ~/.olddotfiles/
cp ~/.vimrc ~/.olddotfiles/.vimrc
cp ~/.bash_profile ~/.olddotfiles/.bash_profile

if [ -e "~/.config/fish/config.fish" ]; then
  cp ~/.config/fish/config.fish ~/.olddotfiles/config.fish
fi

# remove

rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bash_profile
rm -f ~/.config/fish/config.fish

# deploy
if [ -e "/usr/local/bin/fish" ]; then
  mkdir -p ~/.dotfiles/config.fish 
  ln -s ~/.dotfiles/config.fish ~/.config/fish/config.fish
fi

ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile

