#!/usr/bin/env bats
load test_helper

setup() {
  dokku "$PLUGIN_COMMAND_PREFIX:create" ls
}

teardown() {
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
}

@test "($PLUGIN_COMMAND_PREFIX:info) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:info) error when service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info" not_existing_service
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:info) success" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls
  local password="$(sudo cat "$PLUGIN_DATA_ROOT/ls/PASSWORD")"
  assert_contains "${lines[*]}" "http://ls:$password@dokku-couchdb-ls:5984/ls"
}

@test "($PLUGIN_COMMAND_PREFIX:info) replaces underscores by dash in hostname" {
  dokku "$PLUGIN_COMMAND_PREFIX:create" test_with_underscores
  run dokku "$PLUGIN_COMMAND_PREFIX:info" test_with_underscores
  local password="$(sudo cat "$PLUGIN_DATA_ROOT/test_with_underscores/PASSWORD")"
  assert_contains "${lines[*]}" "http://test_with_underscores:$password@dokku-couchdb-test-with-underscores:5984/test_with_underscores"
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" test_with_underscores
}

@test "($PLUGIN_COMMAND_PREFIX:info) success with flag" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --dsn
  local password="$(sudo cat "$PLUGIN_DATA_ROOT/ls/PASSWORD")"
  assert_output "http://ls:$password@dokku-couchdb-ls:5984/ls"

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --config-dir
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --data-dir
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --dsn
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --exposed-ports
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --id
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --internal-ip
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --links
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --service-root
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --service-root
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --status
  assert_success

  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --version
  assert_success
}

@test "($PLUGIN_COMMAND_PREFIX:info) error when invalid flag" {
  run dokku "$PLUGIN_COMMAND_PREFIX:info" ls --invalid-flag
  assert_failure
}
