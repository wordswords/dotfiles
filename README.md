# My .dotfiles

![Alt text](https://i.imgur.com/UNar5Rm.png "VIM setup")

# Features

My setup with custom settings for bash, zsh osx and vim, with some extra ~/bin helper scripts for good measure. Tested on OSX,Linux Mint and Raspbian Linux.

## Shell:

![Alt text](https://i.imgur.com/IN1SwL7.png "My zsh setup")


# Requirements

1. You have to use a ‘Nerd font’ - this is a specially patched font with extra symbol characters for use in vim.
2. vim8 must be installed.
3. git must be installed and setup with ssh for github.
4. shellcheck must be installed for Bash linting.
5. python3 and pip3 must be installed.
6. For shell formatting shfmt should be installed.
7. 
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
5. ‘&gt;&gt;’ and ‘&lt;&lt;’ to adjust indentation.
6. ‘]s’ and ‘\[s’ to browse through spelling errors/grammar errors in text modes such as raw text and markdown.
7. 'K' to bring up documentation on the current term and use the mousewheel to scroll the info.
8. 'gd' to go to the definition of function or class.
9. ':G <git command>' to run a git command via vim-fugative, for example git diff, git add
10. Use '/' and s and start typing to quickly jump to a certain term across all open buffers.
11. Use 'u' to go up a root directory on nerdtree.
12. Use '&lt;F12&gt;' to toggle distraction-free writing mode.
13. Use ':Format' to format a buffer by the coc language server's prettifer, where it exists.
14. The &lt;Leader&gt; key is set to '\\' - use it to access a whole lot of extra coc options.
15. Type :Wordy<space><tab> to use the Wordy proofreading tool to check for poor words while writing, then use <LEFT> and <RIGHT>
16. Type :LanguageToolCheck' to use the command-line grammar and spelling checker (requires Java 8)

# VIM Spellchecking/Grammar checking/Proofreading commands

1. &lt;LEFT&gt;       - prev text error
2. &lt;RIGHT&gt;      - next text error
3. `zg`			 - Mark as a good word
4. `zw`			 - Like `zg` but mark the word as a wrong (bad) word.
5. `zug`         - Unmark as good word
6. `zuw`         - Unmark as wrong (bad) word 
7. `z=`			 - For the word under/after the cursor suggest correctly spelled words
8. `1z=`		 - Use the first suggestion, without prompting
9. `.`           - Redo - repeat last word replacement
10. `:spellr`    - Repeat the replacement done by `z=` for all matches with the replaced 
word in the current window

# Modifying

If you want, you can fork this repo and base your config on this. If you have any problems using these dotfiles please let me know and I can help you.

