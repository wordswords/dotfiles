# My dotfiles

# Features

My setup with custom settings for bash, zsh and vim.

## Vim:

![Alt text](http://i.imgur.com/ghAavTh.png "My vim setup")

## Shell:

![Alt text](http://i.imgur.com/aMrGjDy.png "My zsh setup")

# Requirements

1. I use iterm2 on OSX, this setup will only work for that. i
2. You have to use a ‘Nerd font’ - this is a specially patched font with extra symbol characters for use in vim.
![Alt text](https://i.imgur.com/TOMXk1o.png "iTerm 2 setup")
3. vim must be installed via homebrew
4. git must be installed and setup with ssh for github
5. eslint must be installed for JavaScript linting
6. shellcheck must be installed for Bash linting
7. Ctags can be optionally installed via brew for Ctag-like search

As part of the process, this will install the latest version of oh-my-zsh and set your default shell to it.

# Install

1. git clone git@github.com:/wordswords/dotfiles ./dotfiles/
2. cd ~/.dotfiles/
3. ./deploy-part-1.sh
3. Press control-D to drop out of oh-my-zsh
4. ./deploy-part-2.sh
5. Install a Nerd font (https://nerdfonts.com/) if you are using iterm2
6. Open a new terminal to load everything in
7. You're good to go.

If you want, you can fork this repo and base your config on this. If you have any problems using these dotfiles please let me know and I can help you.

