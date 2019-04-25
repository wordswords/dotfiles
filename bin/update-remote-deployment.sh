#!/bin/bash

##
###  Script to update .dotfiles
##

# get parameters
if [ $# -eq 1 ]; then
  # parameters passed on command line
  HOST_TO_DEPLOY=$1
else
  echo "Full Hostname or IP address of machine to deploy to. (Must have a user account named ${USER} already setup):"
  read -r HOST_TO_DEPLOY
fi

echo -n
echo "Shall we go ahead updating the deployment of ${USER}@${HOST_TO_DEPLOY}? (y/N)"
read -r answer
if echo "${answer}" | grep -iq "^y" ;then
  echo "Proceeding..";
else
  echo "Quitting..";
  exit;
fi

rsync -ave ssh ~/.dotfiles "${USER}@${HOST_TO_DEPLOY}:~/"

# clean up
echo
echo "Completed."
echo



