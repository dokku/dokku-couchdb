#!/usr/bin/env bats
load test_helper

setup() {
  dokku "$PLUGIN_COMMAND_PREFIX:create" ls
}

teardown() {
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
}

@test "($PLUGIN_COMMAND_PREFIX:pause) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:pause"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:pause) error when service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:pause" not_existing_service
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:pause) success" {
  run dokku "$PLUGIN_COMMAND_PREFIX:pause" ls
  assert_success
}
