#!/bin/bash 

## 
### Script to copy local public ssh key and ~/.bash_profile_remote file to a given host
### and setup an alias in ~/.bash_aliases for quick keyed login
## 

echo "Hostname or IP address of machine to deploy to. (Must have a user account named ${USER} already setup):"
read HOST_TO_DEPLOY
echo "Short memorable unique bash alias for this host:"
read ALIAS
echo "Shall we go ahead deploying to ${USER}@${HOST_TO_DEPLOY} and memorable alias: ${ALIAS}? (y/N)"
read answer
if echo "${answer}" | grep -iq "^y" ;then
  echo "Proceeding..";
else
  echo "Quitting..";
  exit;
fi
ssh "${USER}@${HOST_TO_DEPLOY}" "mkdir -p ~/.ssh"
scp ~/.bash_profile_remote "${USER}@${HOST_TO_DEPLOY}:~/.bash_profile"
cat ~/.ssh/id_rsa.pub | ssh "${USER}@${HOST_TO_DEPLOY}" 'cat >> .ssh/authorized_keys'
ssh "${USER}@${HOST_TO_DEPLOY}" "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"
echo "alias ${ALIAS}='ssh ${USER}@${HOST_TO_DEPLOY}'" >> ~/.bash_aliases
echo -n >> ~/.bash_aliases
source ~/.bash_aliases
echo "New list of your aliases:"
alias
echo "Completed. Ready to try new alias: ${ALIAS}"

