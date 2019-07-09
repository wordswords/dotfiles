# My .dotfiles

# Features

My setup with custom settings for bash, zsh osx and vim, with some extra ~/bin helper scripts for good measure.

## Vim:

![Alt text](https://i.imgur.com/LsisDfP.png "My vim setup")

## Shell:

![Alt text](https://i.imgur.com/IN1SwL7.png "My zsh setup")

# Requirements

1. I use iterm2 on OSX, this setup will only work for that.
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

# VIM keybindings

1. <Tab> to activate autocomplete plugins specific to Python and CPP modes, and then the default autocomplete of vim after that
2. Down cursor arrow to launch a shell-based grep through a path while editing a source file, and when you’ve done that:
3. Left and right cursor arrows to move through the search results of above grep
4. ‘>>’ and ‘<<’ to adjust indentation
5. ‘]s’ and ‘[s’ to browse through spelling errors/grammar errors in text modes such as raw text, markdown etc

# Modifying

If you want, you can fork this repo and base your config on this. If you have any problems using these dotfiles please let me know and I can help you.

