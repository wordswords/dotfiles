#!/bin/bash

export machinealias="${1}"
export line="${@:2}"
shopt -s expand_aliases
source ~/.bash_aliases
export cmd="-t 'bash -l -c \" ${line};exit;bash\"'"
echo "Prepared >>>${machinealias} ${cmd}<<< and sent it to the local clipboard"
echo "${machinealias} ${cmd}" | pbcopy


