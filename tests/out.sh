#!/bin/bash

set -e -u

# Include the function to be tested
script_location="./../assets/out"

setup_suite() {
  source ./../assets/out
}

set_check_team_membership_response_status_code() {
  local response_status_code="$1"
  fake check_team_membership << EOF
    $response_status_code
EOF
}

# ====================================================
# GitHub User Validation Tests
# ====================================================

test_validates_gh_user() {
  test_user='test-user'
  payload='{"params":{},"source":{"access_token":"test-access-token","org":"test-org","users":["'$test_user'"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=$(jq -n "{version:{version:\"v\"}}")
  expected_exit_code=0
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

test_invalidates_gh_user() {
  test_user='test-user'
  payload='{"params":{},"source":{"access_token":"test-access-token","org":"test-org","users":["'$test_user'"]}}'
  result=$(BUILD_CREATED_BY="invalid-user" BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=''
  expected_exit_code=1
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a non-zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return an empty output"
}

test_validates_gh_user_when_multiple_users_teams() {
  set_check_team_membership_response_status_code 1
  test_user='test-user'
  payload='{"params":{},"source":{"access_token":"test-access-token","org":"test-org","users":["test-user","jdoe1","jdoe2"],"teams":["test-team-1","test-team-2"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=$(jq -n "{version:{version:\"v\"}}")
  expected_exit_code=0
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

# ====================================================
# GitHub Team Validation Tests
# ====================================================

test_validates_gh_team() {
  set_check_team_membership_response_status_code 0
  test_user='test-user'
  test_team='test-team'
  payload='{"params":{},"source":{"access_token":"test-access-token","org":"test-org","users":[],"teams":["'$test_team'"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=$(jq -n "{version:{version:\"v\"}}")
  expected_exit_code=0
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

test_invalidates_gh_team() {
  set_check_team_membership_response_status_code 1
  test_user='test-user'
  test_team='test-team'
  payload='{"params":{},"source":{"access_token":"test-access-token","org":"test-org","users":[],"teams":["invalid-team"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=''
  expected_exit_code=1
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}


test_validates_gh_team_multiple_users_teams() {
  set_check_team_membership_response_status_code 0
  test_user='test-user'
  test_team='test-team'
  payload='{"params":{},"source":{"access_token":"test-access-token","org":"test-org","users":["test-user","jdoe1","jdoe2"],"teams":["'$test_team'","test-team-2"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=$(jq -n "{version:{version:\"v\"}}")
  expected_exit_code=0
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

# ====================================================
# GitHub Enterprise Team Validation Tests
# ====================================================

test_validates_ghe_team() {
  set_check_team_membership_response_status_code 0
  test_user='test-user'
  test_team='test-team'
  payload='{"params":{},"source":{"access_token":"test-access-token","ghe_host":"test-ghe_host","org":"test-org","users":[],"teams":["'$test_team'"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=$(jq -n "{version:{version:\"v\"}}")
  expected_exit_code=0
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

test_invalidates_ghe_team() {
  set_check_team_membership_response_status_code 1
  test_user='test-user'
  test_team='test-team'
  payload='{"params":{},"source":{"access_token":"test-access-token","ghe_host":"test-ghe_host","org":"test-org","users":[],"teams":["'$test_team'"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=''
  expected_exit_code=1
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

# ====================================================
# GitHub Org validation tests
# ====================================================

test_validates_gh_org() {
  set_check_org_membership_response_status_code 0
  test_user='test-user'
  test_org='test_org'
  payload='{"params":{},"source":{"access_token":"test-access-token","org":"'$test_org'","users":[],"teams":["test_team"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=$(jq -n "{version:{version:\"v\"}}")
  expected_exit_code=1
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

test_invalidates_gh_org() {
  set_check_org_membership_response_status_code 1
  test_user='test-user'
  test_org='test_org'
  payload='{"params":{},"source":{"access_token":"test-access-token","org":"'$test_org'","users":[],"teams":["test_team"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=''
  expected_exit_code=1
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

# ====================================================
# GitHub Enerprise Org validation tests
# ====================================================

test_validates_gh_org() {
  set_check_org_membership_response_status_code 0
  test_user='test-user'
  test_org='test_org'
  payload='{"params":{},"source":{"access_token":"test-access-token","ghe_host":"test-ghe_host","org":"'$test_org'","users":[],"teams":["test_team"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=$(jq -n "{version:{version:\"v\"}}")
  expected_exit_code=1
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}

test_invalidates_gh_org() {
  set_check_org_membership_response_status_code 1
  test_user='test-user'
  test_org='test_org'
  payload='{"params":{},"source":{"access_token":"test-access-token","ghe_host":"test-ghe_host","org":"'$test_org'","users":[],"teams":["test_team"]}}'
  result=$(BUILD_CREATED_BY=$test_user BUILD_JOB_NAME="test-build-job" $script_location "$payload")
  exit_code=$?
  expected_result=''
  expected_exit_code=1
  echo "actual result: $result"
  assert_equals "$expected_exit_code" "$exit_code" "the out script should return a zero exit code"
  assert_equals "$expected_result" "$result" "the out script should return a valid output"
}
