#!/bin/bash

# backup
rm -rf ~/.olddotfiles
mkdir -p ~/.olddotfiles
cp -R ~/.vim ~/.olddotfiles/
cp ~/.vimrc ~/.olddotfiles/.vimrc
cp ~/.bash_profile ~/.olddotfiles/.bash_profile

# remove

rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bash_profile
rm -f ~/.config/fish/config.fish

ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile

# install vim plugins latest versions

rm -rf ~/.dotfiles/.vim/bundle/*
cd ~/.dotfiles/.vim/bundle/
git clone git@github.com:vim-scripts/Conque-Shell.git
git clone git@github.com:ryanoasis/vim-devicons.git
git clone git://github.com/tpope/vim-rails.git
git clone git://github.com/tpope/vim-bundler.git
git clone git@github.com:dag/vim-fish.git
git clone https://github.com/vim-airline/vim-airline
git clone git@github.com:scrooloose/nerdtree.git

# install font for vim-fonts
cd ~/Library/Fonts
curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
cd -
echo "If using iterm2, remember to now manually set your font in iterm2 settings to Droid Sans Mono for Powerline both for ASCII and non-ASCII font types!"
