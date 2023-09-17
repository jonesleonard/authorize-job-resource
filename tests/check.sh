#!/bin/bash

set -e -u

# Include the function to be tested
script_location="$(dirname "$0")"/../assets/check

# shellcheck source=./../assets/check
#source "$script_location"

it_has_valid_output() {
  result=$($script_location)
  echo "actual result: $result"
  expected='[{ "version": "" }]'
  if [ "$result" != "$expected" ]; then
      echo "FAILED it_has_valid_output: Result is not as expected"
      exit 1
  else
      echo "PASSED it_has_valid_output"
  fi
}

it_has_valid_output