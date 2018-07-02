#!/bin/bash

FREEZE=false
SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

function set_aliases() {
  
  # TODO: Update ranking algorithm so it's performant with more aliases.
  cat "${SCRIPT_DIR}/data/COMMAND_LOG.txt" | sort | uniq -c >> "${SCRIPT_DIR}/data/SORTED_COMMANDS.txt"
  awk -F ' ' '{a[$2]+=$1}END{for(i in a) print "     "a[i]" "i}' "${SCRIPT_DIR}/data/SORTED_COMMANDS.txt" > "${SCRIPT_DIR}/data/tmpfile.txt"
  cat "${SCRIPT_DIR}/data/tmpfile.txt" | sort -rn > "${SCRIPT_DIR}/data/SORTED_COMMANDS.txt"

  IFS=$'\n'

  while read l; do
    new_alias=$(echo $l | sed -r 's/(.*\/)+//g')
    alias_filepath=$(echo $l | sed -r 's/.*[ ]//g')

    if ! type $new_alias 2> /dev/null; then
      alias $new_alias="cd $alias_filepath"
    fi
  done <"${SCRIPT_DIR}/data/SORTED_COMMANDS.txt"
}

i=0

function capture_input() {
  if [ "$FREEZE" = false ]; then
    i=$(($i+1))

    if [ $(($i%10)) == 0 ]; then
      set_aliases > /dev/null
    fi
    echo $PWD >> "${SCRIPT_DIR}/data/COMMAND_LOG.txt"
  fi
}

function load_aliases() {
  IFS=$'\n'

  while read l; do
    new_alias=$(echo $l | sed -r 's/(.*\/)+//g')
    alias_filepath=$(echo $l | sed -r 's/.*[ ]//g')

    if ! type $new_alias 2> /dev/null; then
      alias $new_alias="cd $alias_filepath"
    fi
  done <"${SCRIPT_DIR}/data/SAVED.txt"
}

function pw() {
  declare opt
  declare OPTARG
  declare OPTIND

  while getopts "crs:d:fu" opt; do
    case $opt in
      "c")
        # TODO: Print out columns with count, filepath, and alias here
        # TODO: Provide all option with scrolling functionality.
        cat "${SCRIPT_DIR}/data/SORTED_COMMANDS.txt" | head -5;;
      "r")
        : > "${SCRIPT_DIR}/data/SORTED_COMMANDS.txt"
        : > "${SCRIPT_DIR}/data/COMMAND_LOG.txt";;
      "s")
        alias_filepath=$(cat "${SCRIPT_DIR}/data/SORTED_COMMANDS.txt" | sed -rn "/${OPTARG}+$/p" | sed -r "s/.*\s.*[0-9]\s//g")
        echo "${alias_filepath}" >> "${SCRIPT_DIR}/data/SAVED.txt"
        ;;
      "d")
        old_alias=${OPTARG}
        unalias $old_alias
        # TODO: Remove aliases from saved file.
        ;;
      "f")
        if [ "$FREEZE" = false ]; then
          FREEZE=true
        fi
        ;;
      "u")
        if [ "$FREEZE" = true ]; then
          FREEZE=false
        fi
        ;;
      "i")
        # TODO: Ignore files and filepaths. Source local gitignores.
        ;;
    esac
  done
}

export -f pw

if [ ! -d "${SCRIPT_DIR}/data" ]; then
  mkdir "${SCRIPT_DIR}/data"
fi

if [ -f "${SCRIPT_DIR}/data/SAVED.txt" ]; then
  load_aliases > /dev/null
fi

if [ -f "${SCRIPT_DIR}/data/COMMAND_LOG.txt" ]; then
  set_aliases > /dev/null
fi

PROMPT_COMMAND="$PROMPT_COMMAND capture_input"
