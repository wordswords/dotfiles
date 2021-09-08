# My .dotfiles

# Features

My setup with custom settings for bash, zsh osx and vim, with some extra ~/bin helper scripts for good measure. Tested on OSX and Raspbian Linux.

## Vim:

![Alt text](https://i.imgur.com/LsisDfP.png "My vim setup")

## Shell:

![Alt text](https://i.imgur.com/IN1SwL7.png "My zsh setup")

# Requirements

1. You have to use a ‘Nerd font’ - this is a specially patched font with extra symbol characters for use in vim.
![Alt text](https://i.imgur.com/TOMXk1o.png "iTerm 2 setup")
2. vim8 must be installed
3. git must be installed and setup with ssh for github
4. shellcheck must be installed for Bash linting

As part of the process, this will install the latest version of oh-my-zsh and set your default shell to it.

# Install

1. git clone git@github.com:/wordswords/dotfiles ./dotfiles/
2. cd ~/.dotfiles/
3. ./deploy-part-1.sh
4. Press control-D to drop out of oh-my-zsh
5. ./deploy-part-2.sh

# Shell shortcuts

1. Control-L for autocomplete based on your command line
2. Control-R for nice access to bash history
3. Control-+ for smart autocomplete based on your command line
4. Type a directory name accessible from your current directory to cd to that directory, no need to type cd
5. Type ‘l’ for a long-style ls

# VIM keybindings

1. &lt;Tab&gt; to activaue autocomplete plugins specific to Python and CPP modes, and then the default autocomplete of vim after that
2. Down cursor arrow to launch a shell-based grep through a path while editing a source file, and when you’ve done that:
3. Left and right cursor arrows to move through the syntaxic errors 
4. Up cursor to toggle the file browser/NERDTree buffer
5. ‘>>’ and ‘<<’ to adjust indentation
6. ‘]s’ and ‘[s’ to browse through spelling errors/grammar errors in text modes such as raw text, markdown etc

# Modifying

If you want, you can fork this repo and base your config on this. If you have any problems using these dotfiles please let me know and I can help you.

