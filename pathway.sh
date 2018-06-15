#!/bin/bash

SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

function capture_input() {
  echo $PWD >> ${SCRIPT_DIR}/TESTHISTFILE.txt
}

PROMPT_COMMAND="$PROMPT_COMMAND capture_input"
