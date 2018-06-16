#!/bin/bash


# TODO: Every 25 bash commands calculate/recalculate the path aliases

# TODO: At 500 path aliases, begin decrementing the number of commands by 25

# TODO: Iterate through commands, storing the path as a key and the number of
# occurrences as the value

# TODO: Take a default of the top 25 most common directories and dynamically alias
# them by making the final folder the alias. If multiple directories have the
# same name, keep track of them and allow the user to select from a menu.

# TODO: Allow users to purge certain directory aliases

# TODO: Allow users to whitelist certain aliases in case they're already in use

SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )


function set_aliases() {
  ${SCRIPT_DIR}/TESTHISTFILE.txt | sort | uniq -c >> SORTED_COMMANDS.txt
  
  for l in ${SCRIPT_DIR}/SORTED_COMMANDS.txt
  do
    echo $l | sed -r 's/(.*\/)+//g'
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
