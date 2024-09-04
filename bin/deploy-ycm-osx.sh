#!/bin/bash

set -e
set -x

# Install YCM

export PATH="/opt/homebrew/opt/python@3.9/libexec/bin:$PATH"
sudo rm -rf ~/.vim/bundle/YouCompleteMe | true
mkdir -p ~/.vim/bundle/YouCompleteMe
chmod -R 700 ~/.vim/bundle/YouCompleteMe/ | true
cd ~/.vim/bundle/YouCompleteMe/
git clone git@github.com:ycm-core/YouCompleteMe.git ./

cd ~/.vim/bundle/YouCompleteMe/
git submodule update --init --recursive
python3 install.py --cs-completer --java-completer --ts-completer

