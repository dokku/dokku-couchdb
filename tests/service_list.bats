#!/usr/bin/env bats
load test_helper

setup() {
  dokku "$PLUGIN_COMMAND_PREFIX:create" ls
}

teardown() {
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
}

@test "($PLUGIN_COMMAND_PREFIX:list) with no exposed ports, no linked apps" {
  run dokku --quiet "$PLUGIN_COMMAND_PREFIX:list"
  assert_output "ls"
}

@test "($PLUGIN_COMMAND_PREFIX:list) when there are no services" {
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
  run dokku "$PLUGIN_COMMAND_PREFIX:list"
  assert_output "${lines[*]}" "There are no $PLUGIN_SERVICE services"
  dokku "$PLUGIN_COMMAND_PREFIX:create" ls
}
