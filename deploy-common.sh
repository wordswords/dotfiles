#!/usr/bin/env bash
# Common functions for deploy scripts

export CLICOLOR=1

report_progress() {
  level=$1
  message=$2
  level_char=$(printf '+%.0s' $(seq 1 $level))
  echo
  echo -e "\e[0;36m${level_char} ${message}\e[0m"
  echo
}

get_os() {
  uname_s="$(uname -s)"
  if echo $uname_s | grep 'Darwin' >/dev/null
  then
    baseos='osx'
  else
    baseos='linux'
  fi
  echo $baseos
}

