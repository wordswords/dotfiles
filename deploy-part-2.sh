#!/bin/bash

# Configure OSX and brew install packages
./configure-osx.sh

# To be run after installation of oh-my-zsh

# install oh-my-zsh plugins
cd ~/.oh-my-zsh/plugins || exit 1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

rm -rf ~/.zshrc # remove the default .zshrc generated by the oh-my-zsh install

ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.bash_aliases ~/.zsh_aliases
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bash_profile_remote ~/.bash_profile_remote
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/bin ~/bin
mkdir -p ~/bin/
ln -s ~/.dotfiles/deploy-remote-home.sh ~/bin/deploy-remote-home.sh

# install vim plugins latest version
rm -rf ~/.dotfiles/.vim/bundle/*
cd ~/.dotfiles/.vim/bundle/ || exit 1

git clone git@github.com:/godlygeek/tabular.git
git clone git@github.com:/ryanoasis/vim-devicons.git
git clone git@github.com:/scrooloose/nerdtree.git
git clone git@github.com:/tpope/vim-bundler.git
git clone git@github.com:/tpope/vim-fugitive.git
git clone git@github.com:/tpope/vim-git
git clone git@github.com:/tpope/vim-rails.git
git clone git@github.com:/vim-airline/vim-airline
git clone git@github.com:/vim-scripts/Conque-Shell.git
git clone git@github.com:dpelle/vim-LanguageTool
git clone git@github.com:jelera/vim-javascript-syntax.git
git clone git@github.com:junegunn/goyo.vim
git clone git@github.com:junegunn/limelight.vim
git clone git@github.com:kana/vim-textobj-user
git clone git@github.com:reedes/vim-lexical
git clone git@github.com:reedes/vim-litecorrect
git clone git@github.com:reedes/vim-pencil
git clone git@github.com:reedes/vim-textobj-quote
git clone git@github.com:reedes/vim-textobj-sentence
git clone git@github.com:rhysd/vim-grammarous
git clone git@github.com:vim-syntastic/syntastic.git
git clone git@github.com:LucHermitte/lh-vim-lib.git~
git clone git@github.com:LucHermitte/lh-vim-lib.git
git clone git@github.com:LucHermitte/lh-style.git
git clone git@github.com:LucHermitte/lh-tags.git
git clone git@github.com:LucHermitte/lh-dev.git
git clone git@github.com:LucHermitte/lh-brackets.git
git clone git@github.com:LucHermitte/searchInRuntime.git
git clone git@github.com:LucHermitte/mu-template.git
git clone git@github.com:tomtom/stakeholders_vim.git
git clone git@github.com:LucHermitte/alternate-lite.git
git clone git@github.com:LucHermitte/lh-cpp.git

# update docs
vim -u NONE -c "helptags vim-fugitive/doc" -c q
vim -u NONE -c "helptags lh-cpp/doc" -c q

# install oh-my-zsh plugins
cd ~/.oh-my-zsh/plugins || exit 1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

# install font for vim-fonts
brew tap caskroom/fonts
brew cask install font-hack-nerd-font

echo ""
echo ""
echo " -!-!-!- "
echo "STOP - If using iterm2, set your font in iterm2 settings to a Powerline font both for ASCII and non-ASCII font types!"
echo "and then run deploy-iterm2-default-profile.sh"
echo " -!-!-!- "
echo "ONCE DONE - open new terminal and you're complete"
echo ""
echo ""


