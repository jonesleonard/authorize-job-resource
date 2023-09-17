#!/bin/bash

set -e -u

# capture test script locations
echo "***********************RUNNING CHECK TESTS***********************"
source "$(dirname "$0")"/check.sh
