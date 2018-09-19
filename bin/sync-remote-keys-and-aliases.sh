#!/bin/bash

##
## Script to sync local ssh keys and aliases with remote hosts
##

# get parameters
if [ $# -eq 1 ]; then
  # parameters passed on command line
  HOST_TO_DEPLOY=$1
else
  echo "Hostname or IP address of machine to sync to. (Must have a user account named ${USER} already setup):"
  read HOST_TO_DEPLOY
  echo "Current list of aliases:"
  echo
  cat ~/.bash_aliases
  echo
  echo "Shall we go ahead syncing to ${USER}@${HOST_TO_DEPLOY}? (y/N)"
  read answer
  if echo "${answer}" | grep -iq "^y" ;then
    echo "Proceeding..";
  else
    echo "Quitting..";
    exit;
  fi
fi

# deploy ssh keys
rsync -ave ssh ~/.ssh "${USER}@${HOST_TO_DEPLOY}:~/"
rsync -ave ssh ~/.bash_aliases "${USER}@${HOST_TO_DEPLOY}:~/"

# clean up
echo
echo "Completed."
echo



