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
      echo "Assertion failed: Result is not as expected"
      exit 1
  fi
}

it_has_valid_output