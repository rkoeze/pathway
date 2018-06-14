#!/bin/bash

SCRIPT_DIR=$(dirname -- {$(readlink -f -- {$BASH_SOURCE})})

function capture_input() {
  echo $(pwd);
  echo "{$PWD}" >> ${SCRIPT_DIR}/TESTHISTFILE.txt
}

PROMPT_COMMAND="$PROMPT_COMMAND capture_input"
