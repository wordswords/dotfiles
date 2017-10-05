#!/bin/bash

##
### Script to copy local public ssh key and remote dotfiles to a given host
### and setup an alias in ~/.zsh_aliases and ~/.bash_aliases for quick keyed login
##
if [ $# -eq 2 ]; then
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

# setup .dotfiles
rsync -ave ssh ~/.dotfiles "${USER}@${HOST_TO_DEPLOY}:~/"
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/.vim ${HOME}/.vim'
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/.vimrc ${HOME}/.vimrc'
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/bin ${HOME}/bin'
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/.bash_profile_remote ${HOME}/.bash_profile'
ssh "${USER}@${HOST_TO_DEPLOY}" 'ln -sf ${HOME}/.dotfiles/.bashrc_remote ${HOME}/.bashrc'
ssh "${USER}@${HOST_TO_DEPLOY}" "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"

# update aliases
echo "alias ${ALIAS}='ssh ${USER}@${HOST_TO_DEPLOY}'" >> /tmp/new_aliases
echo -n >> /tmp/new_aliases
cat /tmp/new_aliases >> ~/.zsh_aliases
cat /tmp/new_aliases >> ~/.bash_aliases
rm /tmp/new_aliases
sort -u ~/.bash_aliases
sort -u ~/.zsh_aliases
source ~/.zsh_aliases
echo "New list of your aliases:"
echo
alias
echo

# clean up
echo "Completed. Ready to try new alias: ${ALIAS} . Press any key to continue.."
read answer
exec zsh

