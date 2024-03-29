#!/usr/bin/env bats
load test_helper

setup() {
  dokku "$PLUGIN_COMMAND_PREFIX:create" ls
}

teardown() {
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
}

@test "($PLUGIN_COMMAND_PREFIX:clone) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:clone"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
  assert_failure
}

@test "($PLUGIN_COMMAND_PREFIX:clone) error when service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:clone" not_existing_service new_service
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
  assert_failure
}

@test "($PLUGIN_COMMAND_PREFIX:clone) error when new service isn't provided" {
  run dokku "$PLUGIN_COMMAND_PREFIX:clone" ls
  assert_contains "${lines[*]}" "Please specify a name for the new service"
  assert_failure
}

@test "($PLUGIN_COMMAND_PREFIX:clone) error when new service already exists" {
  dokku "$PLUGIN_COMMAND_PREFIX:create" new_service
  run dokku "$PLUGIN_COMMAND_PREFIX:clone" ls new_service
  assert_contains "${lines[*]}" "Invalid service name new_service"
  assert_failure

  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" new_service
}

@test "($PLUGIN_COMMAND_PREFIX:clone) success" {
  run dokku "$PLUGIN_COMMAND_PREFIX:clone" ls new_service
  [[ -f $PLUGIN_DATA_ROOT/new_service/ID ]]
  assert_contains "${lines[*]}" "Copying data from ls to new_service"
  assert_contains "${lines[*]}" "Done"
  assert_success

  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" new_service
}
