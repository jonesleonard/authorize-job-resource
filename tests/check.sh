#!/bin/bash

set -e -u

# Include the function to be tested
script_location="$(../assets/check)"

test_output() {
  expected='[{ "version": "" }]'
  assert_equals "$expected" "$script_location" "the check script should return a valid output"
}