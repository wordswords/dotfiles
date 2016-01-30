
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc" # Load the default .bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias ls="ls -Ga"
alias grep="grep --color"
alias cp="cp -av"

# some useful settings taken from crunchbang debian

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=999999
HISTFILESIZE=999999

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

alias httpd="launchctl load /Users/david/Library/LaunchAgents/homebrew.mxcl.httpd24.plist"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
alias "node install"="echo PERHAPS YOU MEANT npm install"

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
