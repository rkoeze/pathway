#!/bin/bash

SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
FREEZE=false

function set_aliases() {

  : > "${SCRIPT_DIR}/SORTED_COMMANDS.txt"
  cat "${SCRIPT_DIR}/COMMAND_LOG.txt" | sort | uniq -c >> "${SCRIPT_DIR}/SORTED_COMMANDS.txt"

  IFS=$'\n'
  for l in $(cat "${SCRIPT_DIR}/SORTED_COMMANDS.txt")
  do

    new_alias=$(echo $l | sed -r 's/(.*\/)+//g')
    alias_filepath=$(echo $l | sed -r 's/.*[ ]//g')

    if ! type $new_alias 2> /dev/null; then
      alias $new_alias="cd $alias_filepath"
    fi

  done
}

i=0

function capture_input() {
  if [ "$FREEZE" = "false" ]; then
    i=$(($i+1))

    if [ $(($i%10)) == 0 ]; then
      set_aliases
    fi

    echo $PWD >> "${SCRIPT_DIR}/COMMAND_LOG.txt"
  fi
}

function pw() {
  declare opt
  declare OPTARG
  declare OPTIND

  while getopts "cns:d:fu" opt; do
    case $opt in
      "c")
        cat "${SCRIPT_DIR}/SORTED_COMMANDS.txt";;
      "n")
        : > "${SCRIPT_DIR}/SORTED_COMMANDS.txt"
        : > "${SCRIPT_DIR}/COMMAND_LOG.txt";;
      "s")
        alias_filepath=$(cat SORTED_COMMANDS.txt | sed -rn '/notes+$/p' | sed -r "s/.*\s.*[0-9]\s//g")
        echo "${alias_filepath}" >> "${SCRIPT_DIR}/SAVED.txt"
        ;;
      "d")
        old_alias=${OPTARG}
        unalias $old_alias
        ;;
      "f")
        if [ "$FREEZE" = "false" ]; then
          $FREEZE=true
        fi
        ;;
      "u")
        if [ "$FREEZE" = "true" ]; then
          $FREEZE=false
        fi
        ;;
    esac
  done
}

export -f pw

function load_aliases() {
  IFS=$'\n'
  for l in $(cat "${SCRIPT_DIR}/SAVED.txt")
  do
    new_alias=$(echo $l | sed -r 's/(.*\/)+//g')
    alias_filepath=$(echo $l | sed -r 's/.*[ ]//g')

    if ! type $new_alias 2> /dev/null; then
      alias $new_alias="cd $alias_filepath"
    fi

  done
}

load_aliases
set_aliases
PROMPT_COMMAND="$PROMPT_COMMAND capture_input"
