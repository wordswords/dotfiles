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

# install font for vim-fonts
cd ~/Library/Fonts
curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
cd -
echo "If using iterm2, remember to now manually set your font in iterm2 settings to Droid Sans Mono for Powerline both for ASCII and non-ASCII font types!"
