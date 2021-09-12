#!/usr/bin/env bats
load test_helper

setup() {
  dokku "$PLUGIN_COMMAND_PREFIX:create" ls
  dokku apps:create my-app
  dokku "$PLUGIN_COMMAND_PREFIX:link" ls my-app
}

teardown() {
  dokku "$PLUGIN_COMMAND_PREFIX:unlink" ls my-app
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" ls
  dokku --force apps:destroy my-app
}

@test "($PLUGIN_COMMAND_PREFIX:promote) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:promote"
  assert_contains "${lines[*]}" "Please specify a valid name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:promote) error when the app argument is missing" {
  run dokku "$PLUGIN_COMMAND_PREFIX:promote" ls
  assert_contains "${lines[*]}" "Please specify an app to run the command on"
}

@test "($PLUGIN_COMMAND_PREFIX:promote) error when the app does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:promote" ls not_existing_app
  assert_contains "${lines[*]}" "App not_existing_app does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:promote) error when the service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:promote" not_existing_service my-app
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:promote) error when the service is already promoted" {
  run dokku "$PLUGIN_COMMAND_PREFIX:promote" ls my-app
  assert_contains "${lines[*]}" "already promoted as COUCHDB_URL"
}

@test "($PLUGIN_COMMAND_PREFIX:promote) changes COUCHDB_URL" {
  password="$(sudo cat "$PLUGIN_DATA_ROOT/ls/PASSWORD")"
  dokku config:set my-app "COUCHDB_URL=http://u:p@host:5984/db" "DOKKU_COUCHDB_BLUE_URL=http://ls:$password@dokku-couchdb-ls:5984/ls"
  dokku "$PLUGIN_COMMAND_PREFIX:promote" ls my-app
  url=$(dokku config:get my-app COUCHDB_URL)
  assert_equal "$url" "http://ls:$password@dokku-couchdb-ls:5984/ls"
}

@test "($PLUGIN_COMMAND_PREFIX:promote) creates new config url when needed" {
  password="$(sudo cat "$PLUGIN_DATA_ROOT/ls/PASSWORD")"
  dokku config:set my-app "COUCHDB_URL=http://u:p@host:5984/db" "DOKKU_COUCHDB_BLUE_URL=http://ls:$password@dokku-couchdb-ls:5984/ls"
  dokku "$PLUGIN_COMMAND_PREFIX:promote" ls my-app
  run dokku config my-app
  assert_contains "${lines[*]}" "DOKKU_COUCHDB_"
}

@test "($PLUGIN_COMMAND_PREFIX:promote) uses COUCHDB_DATABASE_SCHEME variable" {
  password="$(sudo cat "$PLUGIN_DATA_ROOT/ls/PASSWORD")"
  dokku config:set my-app "COUCHDB_DATABASE_SCHEME=couchdb2" "COUCHDB_URL=http://u:p@host:5984/db" "DOKKU_COUCHDB_BLUE_URL=couchdb2://ls:$password@dokku-couchdb-ls:5984/ls"
  dokku "$PLUGIN_COMMAND_PREFIX:promote" ls my-app
  url=$(dokku config:get my-app COUCHDB_URL)
  assert_contains "$url" "couchdb2://ls:$password@dokku-couchdb-ls:5984/ls"
}
