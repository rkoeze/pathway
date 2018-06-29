#!/bin/bash

SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

function set_aliases() {

  : > "${SCRIPT_DIR}/SORTED_COMMANDS.txt"
  cat "${SCRIPT_DIR}/COMMAND_LOG.txt" | sort | uniq -c >> "${SCRIPT_DIR}/COMMAND_LOG.txt"

  IFS=$'\n'
  for l in $(cat "${SCRIPT_DIR}/SORTED_COMMANDS.txt")
  do

    new_alias=$(echo $l | sed -r 's/(.*\/)+//g')
    alias_filepath=$(echo $l | sed -r 's/.*[ ]//g')

    if ! type $new_alias > /dev/null; then
      alias $new_alias="cd $alias_filepath"
    fi

  done
}

i=0

function capture_input() {
  i=$(($i+1))

  echo "current count $i"

  if [ $(($i%10)) == 0 ]; then
    set_aliases
  fi

  echo $PWD >> ${SCRIPT_DIR}/TESTHISTFILE.txt
}


function pw() {
  echo "trying to work"
  while getopts "cd" opt; do
    echo "working"
    case $opt in
      "c")
        cat "${SCRIPT_DIR}/SORTED_COMMANDS.txt";;
      "n")
        : > "${SCRIPT_DIR}/SORTED_COMMANDS.txt"
        : > "${SCRIPT_DIR}/COMMAND_LOG.txt";;
      "s")
        ;;
      "d")
        ;;
    esac
  done
}

export -f pw


PROMPT_COMMAND="$PROMPT_COMMAND capture_input"
