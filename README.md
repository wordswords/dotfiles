# My .dotfiles

![Alt text](https://i.imgur.com/UNar5Rm.png "VIM setup")

# Features

My setup with custom settings for bash, zsh osx and vim, with some extra ~/bin helper scripts for good measure. Tested on OSX, Ubuntu, Linux Mint and Raspbian Linux.

## Shell:

![Alt text](https://i.imgur.com/IN1SwL7.png "My zsh setup")


# Requirements

1. You have to use a ‘Nerd font’ - this is a specially patched font with extra symbol characters for use in vim. This is not a prerequisite, it will show you how to install it at the end of the dotfile deployment.
2. vim8 must be installed.
3. git must be installed and setup with ssh for github.
4. python3 and pip3 must be installed.
5. For grammar checking Java 8 should be installed.
6. Latest versions of Node and npm must be installed.

As part of the process, this will install the latest version of oh-my-zsh and set your default shell to it, and install
the latest version of yarn.

# Install

1. `git clone git@github.com:/wordswords/dotfiles ./dotfiles/`
2. `cd ~/.dotfiles/`
3. `./deploy-part-1.sh`
4. Press `control-D` to drop out of oh-my-zsh
5. `./deploy-part-2.sh`

# Shell shortcuts

1. Control-R for previous commands.
2. Type `z` and a directory name accessible from your current directory to cd to that directory, no need to type cd.
3. Type `l` for a long-style ls.

# VIM Key bindings

1. `<tab>` to activate autocomplete plug ins.
2. Down cursor for vim.coc diagnostics window, except in text mode.
3. Left and right cursor arrows to move through the syntaxic errors.
4. Up cursor to toggle the file browser/NERDTree buffer.
5. `>>` and `<<` to adjust indentation.
6. `set mouse=a` is on, if you have any problems with copying and pasting just :set mouse= beforehand.
7. `K` to bring up documentation on the current term and use the mousewheel to scroll the info.
8. `gd` to go to the definition of function or class.
9. `:G <git command>` to run a git command via vim-fugative, for example `git diff`, `git add`
10. Use `/` and start typing to quickly jump to a certain term across all open buffers.
11. Use `u` to go up a root directory on nerdtree.
12. Use `<F12>` to toggle distraction-free writing mode.
13. Use `:Format` to format a buffer by the coc language server's prettifer, where it exists.
14. The "Leader" key is set to `\` - use it to access a whole lot of extra coc options.
15. Type `:Wordy<space><tab>` to use the Wordy proofreading tool to check for poor words while writing.
16. Type `:LanguageToolCheck`' to use the command-line grammar and spelling checker (requires Java 8).
17. Use `:G blame` to see a line-by-line overview in the editor of what commit touched each line, and who committed it.

# VIM Spellchecking/Grammar checking/Proofreading commands

1. `<LEFT>`       - prev text error
2. `<RIGHT>`      - next text error
3. `zg`			 - Mark as a good word
4. `zw`			 - Like `zg` but mark the word as a wrong (bad) word.
5. `zug`         - Unmark as good word
6. `zuw`         - Unmark as wrong (bad) word 
7. `z=`			 - For the word under/after the cursor suggest correctly spelled words
8. `1z=`		 - Use the first suggestion, without prompting
9. `.`           - Redo - repeat last word replacement
10. `:spellr`    - Repeat the replacement done by `z=` for all matches with the replaced 
word in the current window

# Mergetool - VIMdiff
 
1. When a merge is started and conflicts are found, run `git mergetool`
2. REMOTE = whatever is in the repo, BASE = whatever was the previous commit, LOCAL = whatever is in your local copy
3. Move to the bottom window and the change you want to select `/>>>>` will search through the file for them.
4. `:diffg RE`  " get from REMOTE
5. `:diffg BA`  " get from BASE
6. `:diffg LO`  " get from LOCAL
7. These arguments also work on ranges, for example you can select all of the file and then use a range to `diffg LO`
8. `wq` to save and commit the merge.
 
# Git stuff I keep forgetting

1. `git status` - will tell you what branch you're on and what files have changed. Use this all the time.
2. `git commit --amend` - roll the current commit into the previous one and edit the previous commit message
3. `git branch` - show the current branches on your local copy
4. `git stash push` - push to the stash, puts all non-commited files on the stash
5. `git stash pop` - pop whatever is on to stash to the local copy.
6. `git checkout -b <new branch name>` - create a new branch and switch to it
7. `git rebase -i HEAD~3` - perform an interactive rebase on the last _2_ commits..eg you always want to +1 to the number. Be careful with this.
8. `git pull origin master` or `git pull origin main` - pull and merge master/main into your current local branch
9. Use 'main' instead of 'master' for all future repos - everyone is doing it.
10. `git difftool` - use wherever you would use git diff - it's much more useful.
11. When all goes horribly wrong, backup your changed files, delete your entire local copy, checkout again from master, 
    and rebuild your commit by copying the backed up files in.
12. Use github PR's 'changed files' tab for exactly what has changed, but don't forget the commits tab, there should only 
    usually be one commit per PR. And remember the revert button on Github PRs. 
13. `git logline` for my custom oneline per commit log alias which includes useful extra information, see: https://ma.ttias.be/pretty-git-log-in-one-line/
14. `git checkout -- <filepath>` - this will overwrite your local changes to the file at <filepath> and restore the version in the latest commit on your branch.
15. `git checkout <hash> <filepath>` - this will checkout a previous version of the file from the <hash> commit. A useful technique for restoring a change from a previous commit is to `cp <filepath> <filepath.bak>`, use `git logline` to find the right hash and then, `git checkout <hash> <filepath>`, then use `vimdiff <filepath> <filepath.bak>` to copy a change over from the previous commit to `<filepath.bak>`, and then `rm <filepath>` and `mv <filepath.bak> <filepath>`.

Check out my simpleton Git workflow here: https://github.com/wordswords/dotfiles/blob/master/gitworkflow.md
 
# Modifying

If you want, you can fork this repo and base your config on this. If you have any problems using these dotfiles please let me know and I can help you.

