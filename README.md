# My .dotfiles

My setup with custom settings for bash, zsh and vim, with some extra ~/bin
helper scripts for good measure. Tested on Ubuntu 22.04 and the latest Lubuntu.
I test this on my two main Linux computers, and my work Linux laptop.

## VIM:

![Alt text](https://i.imgur.com/1VeViF2.png "VIM setup")

### How to Decode the vim-airline Buffer Statusline

Full docs: https://github.com/vim-airline/vim-airline

1. The problems in the file are noted in the far right. If there are no problems
there will be no red or orange expanded sections.

* Orange - Warnings
* Red - Errors

2. It will show you how many warnings or errors there are, and the line number of
the first one. You should be able to skip between warnings/errors with the
`<Left>` and `<Right>` keys.

3. When you are searching through the file with `/` then it shows you: your term,
how many matches there are of your term, and which one you're on.

4. Other info displayed includes File Format, file type detected, current line of
code / total lines of code, current column number / total columns, and so on.

5. When it shows 'SPELL' is on, it is checking text spellings in addition to any
code related errors. To toggle this, use `:set nospell` or `:set spell`. It
highlights spelling errors in comments.

### How to decode Nerdtree file status symbols

They correspond to the git status of the file in the repo.

* 'Modified'  :`✹`
* 'Staged'    :`✚`
* 'Untracked' :`✭`
* 'Renamed'   :`➜`
* 'Unmerged'  :`═`
* 'Deleted'   :`✖`
* 'Dirty'     :`✗`
* 'Ignored'   :`☒`
* 'Clean'     :`✔︎`
* 'Unknown'   :`?`

## ZSH:

![Alt text](https://i.imgur.com/yBs7bKu.png "My zsh setup")

ZSH uses oh-my-zsh in Powerlevel10k mode, which provides fast and responsive 
auto-complete options. Just hit `<TAB>` to autocomplete. It will also show the status
of the current Git repo.

https://github.com/romkatv/powerlevel10k

# Installation / Updating

The scripts are designed to install for the first time OR update the current
version. When you install my .dotfiles every time you log into a console, it
will fetch down the latest master from this repo. If there are any changes, you
are advised to rerun the scripts in 'Install Steps' below to keep your copy
uptodate.

## Installation Requirements for .dotfiles

1. You have to use a ‘Nerd font’ - this is a specially patched font with extra
symbol characters for use in vim. This is not a prerequisite, it will show you
how to install it at the end of the dotfile deployment.
2. vim8 must be installed.
3. git must be installed and setup with ssh for github.
4. python3 and pip3 must be installed.
5. For grammar checking Java 8 should be installed.
6. zsh must be installed.

You can run a script that will attempt to install the prerequisites under Ubuntu
by executing `./deploy-part-0.sh`.

## What It Will Install

It will install my VIM8 development environment and anything else I use
regularly in my work. Currently it will:

* Install my heavily customised version of VIM8 with coc.vim and other plugins
* Install latest version of Oh-my-ZSH and set your default shell to ZSH
* Install Joplin the command-line open source Evernote replacement, and secure
it with encryption, and download all my notes (presuming you are me).
* Ask if you want to install my usual apps - https://Morgen.so : a paid multiplatform
calendar app that I use with Google Calendar and Spotify. These are delivered
via the snap installation process.
* Ask if you want to install the excellent Golang JIRA CLI client which makes
navigating JIRA boards less painful.
* Setup 'fortune' with some Ubuntu server tips displayed on login.

You may well have to customise, mix and match, and edit these individual 
settings because  you won't have the authentication required for this whole 
process to work. If you are serious about reusing what I've done, I would 
advise running this setup in a docker container or virtual machine.

## Install Steps

1. `git clone git@github.com:/wordswords/dotfiles ~/.dotfiles`
2. `cd ~/.dotfiles/`
3. `./deploy-part-0.sh` to attempt to install preqs
4. `./deploy-part-1.sh` to install and setup oh-my-zsh
5. Press `control-D` to drop out of oh-my-zsh
6. `./deploy-part-2.sh` to install the vast majority of the customisations
7. By default it sets your git email address to be my address.
You probably want to change this if you're not me!
8. It will also attempt by default to log in to my Joplin account, which will
not succeed without my credentials. So you probably want to change that.

[![asciicast](https://asciinema.org/a/EhIutOkIqGSBwoaZwHQUUJ2wh.svg)](https://asciinema.org/a/EhIutOkIqGSBwoaZwHQUUJ2wh)

# Using the Dotfiles Environment

## Shell shortcuts

1. `<CTRL>-<R>` for previous commands.
2. Type `z` and a directory name accessible from your current directory to cd to
that directory, no need to type cd.
3. Type `l` for a long-style ls.
4. `vimdiff <file1> <file2>` for a nice 2 way diff style interface where you can
analyse and easily copy changes between files.
5. `cat <file> | pbcopy` to cat a file into the local OS clipboard, very useful 
for then using on a website form.
6. Use `<tab>` to activate oh-my-zsh's autocomplete plugins. For example `git
<tab>`
7. Run `repos.sh` to check the branch name of all git repositories under the
current directory. Very useful when you have a number of different projects
that interact with each other and you want to quickly see which repos branches
you have checked out.
8. Use `lockup` to encypt the secure directory. Remember to lock up after yourself!
9. Use `unlock` to un-encypt the secure directory. Remember to lock up after
   yourself!
10. Use `vi` instead of `vim` to load a seperate minimal vim config, useful if
    there are problems with the vim config.
11. Use `notes` to un-encrypt the secure directory, launch Joplin, and then on
    exit, re-enrypt the directory.
12. Use `please` after realising that you needed sudo with the last command, to
    repeat the last command with sudo
13. Use `ports` to list the open ports on the system in a readable way.
14. Use `tree` for a handy diagram of the full directory tree under the current
directory.

## VIM Key bindings

1. `<TAB>` to activate autocomplete plug ins.
2. `,` is set to be the `<Leader>` key in VIM8, use it to trigger shortcuts.
3. `<LEFT>` and `<RIGHT>` cursor arrows to move through the syntaxic errors.
4. `<UP>` to toggle the file browser/NERDTree buffer.
5. `>>` and `<<` to adjust indentation.
6. `set mouse=a` is on, if you have any problems with copying and pasting just
`:set mouse=` beforehand.
7. `K` to bring up documentation on the current term and use the mouse wheel to
scroll the info.
8. `gd` to go to the definition of function or class.
9. `:G <git command>` to run a git command via vim-fugative, for example
`git diff`, `git add`.
10. Use `/` and start typing to quickly jump to a certain term across all open
buffers.
11. Use `u` to go up a root directory on nerdtree.
12. Use `<F12>` to toggle distraction-free writing mode.
13. Use `:Format` to format a buffer by the coc language server's prettifier,
where it exists.
14. Type `:Wordy<space><tab>` to use the Wordy proofreading tool to check for
poor words while writing.
15. Type `:LanguageToolCheck` to use the command-line grammar and spelling
checker (requires Java 8).
16. Vim has a weird non-greedy regex match `.\{-}` which means `.+?`. So to
strip a document of all its html tags use this: `:%s/<.\{-}>/ /g`.
17. To search all instances of `git clone` and replace them with `git submodule
add` on a visual block, use `:<','>s/git clone/git submodule add/`.
18. To feed a visual block through an external command, for example, the NIX
external sort command, `:'<,'>!sort` - this will sort the visual block lines
alphabetically.
19. To execute a command on all lines in a visual block, use the norm
command, for example: `:'<,'> norm i##` after selecting in visual mode to comment
all lines out with a `##`. For the reverse, to uncomment and delete the first
character, use `:'<,'> norm x` after selecting in visual mode.
20. To generate a ctags index for all functions/methods in all languages, run
this command at the root of the source control repo `!ctags -R *`. Then you can
use `gd` to jump to the original definition of the function in any file.
21. If in some modes the backtick character does not insert, try typing it twice
that should insert it properly.
22. To open the URL under the cursor in the default browser use `gx` <- handy!
23. To remove all trailing whitesapce from a file, use `:%s/\s\+$//e` <- handy!
24. To run Prettier on language servers that support this VS Code prettier,
use `:Prettier`

Check out this handy VIM cheatsheet I found here:
https://github.com/wordswords/dotfiles/blob/master/notes/VIMCHEATSHEET.md

## VIM Spellchecking/Grammar checking/Proofreading commands (also Joplin notes)

1. `<LEFT>`       - prev text error
2. `<RIGHT>`      - next text error
3. `<UP>`         - run LanguageToolCheck (requires Java) this checks grammar
4. `<DOWN>`       - toggle NerdTree (the directory index browser)
5. `zg`           - Mark as a good word
6. `zw`           - Like `zg` but mark the word as a wrong (bad) word
7. `zug`          - Unmark as good word
8. `zuw`          - Unmark as wrong (bad) word
9. `z=`           - For the word under/after the cursor suggest correctly spelled
words
10. `1z=`         - Use the first suggestion, without prompting
11. `.`           - Redo - repeat last word replacement
12. `:spellr`     - Repeat the replacement done by `z=` for all matches with the
replaced word in the current window
13. `<F12>`       - Toggle 'Goyo' distraction-free mode.

[![asciicast](https://asciinema.org/a/518234.svg)](https://asciinema.org/a/518234)

## Coc.vim Shortcuts on large software projects

Coc.vim is meant to provide an approximate mapping for Visual Studio Code's
plugins and IntelliSense features onto VIM8 and Neovim. It does this with various
degrees of compatability. Often these features are not currently documented and require
prior knowledge of how the Code editor does things. This URL is the documentation 
for the Code editor: https://docs.microsoft.com/en-us/visualstudio/ide/navigating-code?view=vs-2022

This is an excellent introduction to Coc.vim's objectives: https://samroeca.com/coc-plugin.html

1. `:CocDiagnostics` to show the errors in the current language server.
2. `<LEFT>` for the prev diagnostic error, this should be on any programming
language server.
3. `<RIGHT>` for the next diagnostic error, this should be on any programming
language server.
4. `:CocRename` for language server assisted refactoring by renaming a constant,
e.g. method, variable etc.
5. `gd` to jump to the definition of the language object under the cursor.
6. `gy` to jump to the type definition of the language object under cursor.
7. `gi` to jump to the implementation of the language object under cursor.
8. `gr` to show all references to the language object under cursor.
9. `K` for the language feature under the cursor to pull up the language server
documentation for that feature.
10. `:help coc-nvim` for the reference documentation for Coc.vim

## Git Fugitive Plugin in Vim

1. ``:Git blame`` for line-by-line git blame on current file, select a commit
and press 'o' to open the commit diff with the commit message in a new window.

## Git Fugitive Mergetool

1. Whenever you have a merge conflict, use `git mergetool` to open this.
2. Buffers are setup so [local branch | resulting mergefile | merge in branch]
3. Use `[c` and `]c` to navigate through the conflicts
4. Go to local branch OR merge in branch, select the conflict, and use `dp` to
choose that version.
5. When done, use `:Gwrite!`

More info:
http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/

# Additional Notes

## Git stuff I keep forgetting

1. `git status` - will tell you what branch you're on and what files have
changed. Use this all the time.
2. `git commit --amend` and `git rebase -i HEAD~2` - roll the current commit
into the previous one and edit the previous commit message. Use the rebase to
squash the commit.
3. `git branch` - show the current branches on your local copy
4. `git stash push` - push to the stash, puts all non-committed files on the
stash
5. `git stash pop` - pop whatever is on to stash to the local copy.
6. `git checkout -b <new branch name>` - create a new branch and switch to it
7. `git rebase -i HEAD~3` - perform an interactive rebase on the last _2_
commits.. e.g: you always want to +1 to the number. Be careful with this.
8. `git pull origin master` or `git pull origin main` - pull and merge
master/main into your current local branch
9. Use 'main' instead of 'master' for all future repos - everyone is doing it.
10. `git difftool` - use wherever you would use git diff - it's much more useful.
11. `git mergetool` - use whenever you have merges to make, see above.
12. `blameline` - shell script for line-by-line blame with commit summary.
13. When all goes horribly wrong, backup your changed files by manually
`mv`-ing them out of the repo directory, delete your entire local copy, checkout
again from master, and rebuild your commit by copying the backed up files in.
14. Use github PR's 'changed files' tab for exactly what has changed, but don't
forget the commits tab, there should only usually be one commit per PR. And
remember the revert button on Github PRs.
15. `git logline` for my custom oneline per commit log alias which includes
useful extra information, see: https://ma.ttias.be/pretty-git-log-in-one-line/
16. `git checkout -- <filepath>` - this will overwrite your local changes to
the file at <filepath> and restore the version in the latest commit on your
branch.
17. `git checkout <hash> <filepath>` - this will checkout a previous version of
the file from the <hash> commit. A useful technique for restoring a change from
a previous commit is to `cp <filepath> <filepath.bak>`, use `git logline` to
find the right hash and then, `git checkout <hash> <filepath>`, then use
`vimdiff <filepath> <filepath.bak>` to copy a change over from the previous
commit to `<filepath.bak>`, and then `rm <filepath>` and then
`mv <filepath.bak> <filepath>`.

Check out my simpleton Git workflow here:
https://github.com/wordswords/dotfiles/blob/master/notes/GITWORKFLOW.md

## Docker/Docker Compose stuff I forget

1. `docker system prune -a` - remove all unused Docker container images.
This is essential to do occasionally to reclaim disk space.
2. `docker-compose --rm <service>` - execute <service> providing there is a
docker-compose.yml file in the current directory describing `<service>`.
3. `docker ps` - status information on all running docker containers.
4. `docker-compose ps` - status information on all running docker-compose
services.
5. `docker-compose run <service> <bash_command>` - run a quick bash command.
`<service>` must be a valid docker-compose service. For example `docker-compose
run wordpress cat /etc/issue`.
6. `docker logs <service>` - output the logs for a service. This is the
`<service>` name from `docker-compose ps`.
7. `docker build .` - builds the container described in the `Dockerfile` from
the local directory.

Also checkout the notes I took from the Docker Deep Dive book here:
[https://github.com/wordswords/dotfiles/blob/master/notes/DOCKERNOTES.md](https://github.com/wordswords/dotfiles/blob/master/notes/DOCKERNOTES.md)

## Joplin commandline

1. Use the alias `notes` to open Joplin.
2. Navigate the panes using `<TAB>` key
3. Press enter on an existing note to open it in an editor
4. Type `tc` without `:` to toggle the maximisation levels of the console.
5. Type `:help` for basic help.
6. Type `:help keymap` for hotkeys.
7. Type `/<search term>` to search.
8. Type `mn` to create a new note.
9. Type `tm` to toggle metadata - user created time and lots of other metadata.
10. Write all notes using Markdown so they display optimally across all clients.
11. Press `<DEL>` to delete a selected note.

## JIRA Go Client

1. First you must setup the JIRA Go client with the API key as specified in
the documentation - https://github.com/ankitpokhrel/jira-cli
2. `issues` to show open issues allocated to you.
3. `board` to show the current JIRA board.

## External Scripts

I have written a few helper scripts in ~/.dotfiles/bin

### `repos.sh`

![Alt text](https://i.imgur.com/U0h7a8F.png "repos.sh")

This is like the 'tree' command, it will descend downwards into the current
directory and show which branches the Git repositories under the current
directory are on.

It is useful for getting a general overview of a complex codebase and its 
current checkout state.

### `blameline`

![Alt text](https://i.imgur.com/7kfUGNQ.png "blameline")

This shows a line-by-line git blame on a particular file, e.g. `blameline README.md`
showing the origin commit and a snippet of the commit message. Very useful 
for figuring out how a file was put together.

### `git logline`

![Alt text](https://i.imgur.com/iimaagl.png "git logline")

A compact summary of commits to a directory or file, e.g. `git logline
~/.dotfiles`

# Modifying

If you want, you can fork this repo and base your config on this. If you have
any problems using these dotfiles please let me know and I can help you.
