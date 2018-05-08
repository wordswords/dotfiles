#!/bin/bash -ex
shopt -s expand_aliases
source ~/.zsh_aliases
if [ $# -eq 2 ]; then
  # parameters passed on command line
  MACHINE_ALIAS=$1
  USERNAME_TO_GRANT=$2
  USER=${USER}
else
  echo "grant-sudo.sh <machine-alias> <username-to-grant>"
fi
rm /tmp/grant-sudo-tmp-file.txt || echo ""
${MACHINE_ALIAS} sudo -S whoami | tee /tmp/grant-sudo-tmp-file.txt
if grep -q root /tmp/grant-sudo-tmp-file.txt ; then
  echo "We have root on ${MACHINE_ALIAS}. Finding out sudo group.."
  rm /tmp/grant-sudo-tmp-file.txt

  # get the sudo group
  ${MACHINE_ALIAS} sudo -S groups ${USER} | tee /tmp/grant-sudo-tmp-file.txt
  # remove interactive terminal stuff
  sed -ie '/.*password for.*/d' /tmp/grant-sudo-tmp-file.txt

  # if the sudo group is called 'sudo'
  grep -q sudo /tmp/grant-sudo-tmp-file.txt && ${MACHINE_ALIAS} sudo -S usermod -aG sudo ${USERNAME_TO_GRANT}

  # if the sudo group is called 'wheel'
  grep -q wheel /tmp/grant-sudo-tmp-file.txt && ${MACHINE_ALIAS} sudo -S usermod -aG wheel ${USERNAME_TO_GRANT}

  rm /tmp/grant-sudo-tmp-file.txt
  exit 0
else
  echo "We are not root on ${MACHINE_ALIAS}. exiting.."
  exit 1
fi
