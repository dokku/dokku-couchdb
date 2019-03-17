#!/usr/bin/env bats
load test_helper

setup() {
  dokku "$PLUGIN_COMMAND_PREFIX:create" l >&2
}

teardown() {
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" l >&2
}

@test "($PLUGIN_COMMAND_PREFIX:export) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:export"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:export) error when service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:export" not_existing_service
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:export) success with SSH_TTY" {
  export SSH_TTY=`tty`
  run dokku "$PLUGIN_COMMAND_PREFIX:export" l
  echo "output: $output"
  echo "status: $status"
  password="$(sudo cat "$PLUGIN_DATA_ROOT/l/PASSWORD")"
  assert_exit_status 0
  assert_contains "${lines[-1]}" "docker exec dokku.couchdb.l bash -c DIR=\$(mktemp -d) && couchdb-backup -b -H localhost -d \"l\" -f \"\$DIR/l.json\" -u \"l\" -p \"$password\" > /dev/null && cat \"\$DIR/l.json\" && rm -rf \"\$DIR\""
}

@test "($PLUGIN_COMMAND_PREFIX:export) success without SSH_TTY" {
  unset SSH_TTY
  run dokku "$PLUGIN_COMMAND_PREFIX:export" l
  echo "output: $output"
  echo "status: $status"
  password="$(sudo cat "$PLUGIN_DATA_ROOT/l/PASSWORD")"
  assert_exit_status 0
  assert_contains "${lines[-1]}" "docker exec dokku.couchdb.l bash -c DIR=\$(mktemp -d) && couchdb-backup -b -H localhost -d \"l\" -f \"\$DIR/l.json\" -u \"l\" -p \"$password\" > /dev/null && cat \"\$DIR/l.json\" && rm -rf \"\$DIR\""
}
