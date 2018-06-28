#!/bin/bash

SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

function set_aliases() {
  cat ${SCRIPT_DIR}/TESTHISTFILE.txt | sort | uniq -c >> SORTED_COMMANDS.txt
  
  for l in $(cat "${SCRIPT_DIR}/SORTED_COMMANDS.txt")
  do

    new_alias=$(echo $l | sed -r 's/(.*\/)+//g')
    alias_filepath=$(echo $l | sed -r 's/.*[ ]//g')

    if ! type $new_alias > /dev/null; then
      echo "working!"
      alias $new_alias="cd $alias_filepath"
    fi

  done
}

i=0

function capture_input() {
  i=$(($i+1))
  
  if [ $(($i%10)) == 0 ]; then
    set_aliases
  fi

  echo $PWD >> ${SCRIPT_DIR}/TESTHISTFILE.txt
}

PROMPT_COMMAND="$PROMPT_COMMAND capture_input"
