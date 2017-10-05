#!/bin/bash

##
### Script to copy local public ssh key and ~/.bash_profile_remote file to a given host
### and setup an alias in ~/.zsh_aliases and ~/.bash_aliases for quick keyed login
### and dotfiles
##

# get parameters
if [ $# -eq 2 ]; then
  # parameters passed on command line
  HOST_TO_DEPLOY=$1
  ALIAS=$2
else
  echo "Hostname or IP address of machine to deploy to. (Must have a user account named ${USER} already setup):"
  read HOST_TO_DEPLOY
  echo "Current list of aliases:"
  echo
  alias
  echo
  echo "Pick a short memorable unique bash and zsh alias for this new host:"
  read ALIAS
  echo "Shall we go ahead deploying to ${USER}@${HOST_TO_DEPLOY} and memorable alias: ${ALIAS}? (y/N)"
  read answer
  if echo "${answer}" | grep -iq "^y" ;then
    echo "Proceeding..";
  else
    echo "Quitting..";
    exit;
  fi
fi

# keyed ssh login
ssh "${USER}@${HOST_TO_DEPLOY}" "mkdir -p ~/.ssh"
cat ~/.ssh/id_rsa.pub | ssh "${USER}@${HOST_TO_DEPLOY}" 'cat >> .ssh/authorized_keys'
ssh "${USER}@${HOST_TO_DEPLOY}" "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"

# setup .dotfiles
rsync -ave ssh ~/.dotfiles "${USER}@${HOST_TO_DEPLOY}:~/"
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/.vim ${HOME}/.vim'
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/.vimrc ${HOME}/.vimrc'
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/bin ${HOME}/bin'
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/.bash_profile_remote ${HOME}/.bash_profile'
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/.bashrc_remote ${HOME}/.bashrc'

# update aliases
echo "alias ${ALIAS}='ssh ${USER}@${HOST_TO_DEPLOY}'" >> /tmp/new_aliases
echo -n >> /tmp/new_aliases
cat /tmp/new_aliases >> ~/.zsh_aliases
cat /tmp/new_aliases >> ~/.bash_aliases
rm /tmp/new_aliases
sort -u ~/.bash_aliases >/dev/null
sort -u ~/.zsh_aliases >/dev/null
source ~/.zsh_aliases

# clean up
echo
echo "New list of your aliases:"
echo
alias
echo
echo "Completed. Ready to try new alias: ${ALIAS} . Press any key to continue.."
read answer
exec zsh

