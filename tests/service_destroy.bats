#!/usr/bin/env bats
load test_helper

@test "($PLUGIN_COMMAND_PREFIX:destroy) success with --force" {
  dokku "$PLUGIN_COMMAND_PREFIX:create" ls
  run dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
  assert_contains "${lines[*]}" "container deleted: ls"
}

@test "($PLUGIN_COMMAND_PREFIX:destroy) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:destroy"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:destroy) error when container does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:destroy" non_existing_container
  assert_contains "${lines[*]}" "service non_existing_container does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:destroy) error when container is linked to an app" {
  dokku "$PLUGIN_COMMAND_PREFIX:create" ls
  dokku apps:create app
  dokku "$PLUGIN_COMMAND_PREFIX:link" ls app
  run dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
  assert_contains "${lines[*]}" "Cannot delete linked service"

  dokku "$PLUGIN_COMMAND_PREFIX:unlink" ls app
  run dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
  assert_contains "${lines[*]}" "container deleted: ls"
}
