#!/bin/bash
# Common functions for deploy scripts

report_progress() {
  level=$1
  message=$2
  level_char=$(printf '+%.0s' $(seq 1 $level))
  echo
  echo -e "\e[1m${level_char} ${message}\e[0m"
  echo
}
get_os() {
  uname_s="$(uname -s)"
  if echo $uname_s | grep 'Darwin'
  then
    baseos='osx'
  else
    baseos='linux'
  fi
  echo $baseos $
}

