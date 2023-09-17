#!/bin/bash

set -e -u

# Include the function to be tested
script_location="$(../assets/in)"

test_output() {
  expected='[{ "version": "v" }]'
  assert_equals "$expected" "$script_location" "the in script should return a valid output"
}