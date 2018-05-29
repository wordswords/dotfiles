#!/bin/bash -ex
shopt -s expand_aliases
source ~/.zsh_aliases
if [ $# -eq 2 ]; then
  # parameters passed on command line
  MACHINE_ALIAS=$1
  USERNAME_TO_GRANT=$2
  GROUP_TO_GRANT=$3
  USER=${USER}
else
  echo "add-to-group.sh <machine-alias> <username-to-grant> <group-to-grant>"
fi
rm /tmp/grant-sudo-tmp-file.txt || echo ""
${MACHINE_ALIAS} sudo -S whoami | tee /tmp/grant-sudo-tmp-file.txt
if grep -q root /tmp/grant-sudo-tmp-file.txt ; then
  echo "We have root on ${MACHINE_ALIAS}."
  rm /tmp/grant-sudo-tmp-file.txt

  ${MACHINE_ALIAS} sudo -S usermod -a -G ${GROUP_TO_GRANT} ${USERNAME_TO_GRANT}

  exit 0
else
  echo "We are not root on ${MACHINE_ALIAS}. exiting.."
  exit 1
fi
