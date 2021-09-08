# My .dotfiles

# Features

My setup with custom settings for bash, zsh osx and vim, with some extra ~/bin helper scripts for good measure. Tested on OSX,Linux Mint and Raspbian Linux.

## Vim:

![Alt text](https://i.imgur.com/LsisDfP.png "My vim setup")

## Shell:

![Alt text](https://i.imgur.com/IN1SwL7.png "My zsh setup")

# Requirements

1. You have to use a ‘Nerd font’ - this is a specially patched font with extra symbol characters for use in vim.
![Alt text](https://i.imgur.com/TOMXk1o.png "iTerm 2 setup")
2. vim8 must be installed.
3. git must be installed and setup with ssh for github.
4. shellcheck must be installed for Bash linting.
5. python3 and pip3 must be installed.

As part of the process, this will install the latest version of oh-my-zsh and set your default shell to it, and install
the latest version of node and yarn.

# Install

1. git clone git@github.com:/wordswords/dotfiles ./dotfiles/
2. cd ~/.dotfiles/
3. ./deploy-part-1.sh
4. Press control-D to drop out of oh-my-zsh
5. ./deploy-part-2.sh

# Shell shortcuts

1. Control-R for previous commands.
2. Type 'z' and a directory name accessible from your current directory to cd to that directory, no need to type cd.
3. Type ‘l’ for a long-style ls.

# VIM Key bindings

1. &lt;Tab&gt; to activate autocomplete plug ins.
2. Down cursor for vim.coc diagnostics window, except in text mode.
3. Left and right cursor arrows to move through the syntaxic errors.
4. Up cursor to toggle the file browser/NERDTree buffer.
5. ‘>>’ and ‘<<’ to adjust indentation.
6. ‘]s’ and ‘[s’ to browse through spelling errors/grammar errors in text modes such as raw text and markdown.
7. 'K' to bring up documentation on the current term.
8. 'gd' to go to the definition of function or class.
9. ':G <git command>' to run a git command via vim-fugative, for example git diff, git add
10. Use '/' and s and start typing to quickly jump to a certain term across all open buffers.
11. Use 'u' to go up a root directory on nerdtree.
12. Use '<F12>' to toggle distraction-free writing mode.

# Modifying

If you want, you can fork this repo and base your config on this. If you have any problems using these dotfiles please let me know and I can help you.

