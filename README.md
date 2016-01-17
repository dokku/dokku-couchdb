# dokku couchdb (beta) [![Build Status](https://img.shields.io/travis/dokku/dokku-couchdb.svg?branch=master "Build Status")](https://travis-ci.org/dokku/dokku-couchdb) [![IRC Network](https://img.shields.io/badge/irc-freenode-blue.svg "IRC Freenode")](https://webchat.freenode.net/?channels=dokku)

Official CouchDB plugin for dokku. Currently defaults to installing [CouchDB 1.6](https://hub.docker.com/r/frodenas/couchdb/).

## requirements

- dokku 0.4.0+
- docker 1.8.x

## installation

```shell
# on 0.3.x
cd /var/lib/dokku/plugins
git clone https://github.com/dokku/dokku-couchdb.git couchdb
dokku plugins-install

# on 0.4.x
dokku plugin:install https://github.com/dokku/dokku-couchdb.git couchdb
```

## commands

```
couchdb:clone <name> <new-name>  Create container <new-name> then copy data from <name> into <new-name>
couchdb:connect <name>           NOT IMPLEMENTED
couchdb:create <name>            Create a couchdb service with environment variables
couchdb:destroy <name>           Delete the service and stop its container if there are no links left
couchdb:export <name> > <file>   Export a dump of the couchdb service database
couchdb:expose <name> [port]     Expose a couchdb service on custom port if provided (random port otherwise)
couchdb:import <name> < <file>   Import a dump into the couchdb service database
couchdb:info <name>              Print the connection information
couchdb:link <name> <app>        Link the couchdb service to the app
couchdb:list                     List all couchdb services
couchdb:logs <name> [-t]         Print the most recent log(s) for this service
couchdb:promote <name> <app>     Promote service <name> as COUCHDB_URL in <app>
couchdb:restart <name>           Graceful shutdown and restart of the couchdb service container
couchdb:start <name>             Start a previously stopped couchdb service
couchdb:stop <name>              Stop a running couchdb service
couchdb:unexpose <name>          Unexpose a previously exposed couchdb service
couchdb:unlink <name> <app>      Unlink the couchdb service from the app
```

## usage

```shell
# create a couchdb service named lolipop
dokku couchdb:create lolipop

# you can also specify the image and image
# version to use for the service
# it *must* be compatible with the
# fredonas/couchdb image
export COUCHDB_IMAGE="couchdb"
export COUCHDB_IMAGE_VERSION="1.5"

# you can also specify custom environment
# variables to start the couchdb service
# in semi-colon separated forma
export COUCHDB_CUSTOM_ENV="USER=alpha;HOST=beta"

# create a couchdb service
dokku couchdb:create lolipop

# get connection information as follows
dokku couchdb:info lolipop

# a couchdb service can be linked to a
# container this will use native docker
# links via the docker-options plugin
# here we link it to our 'playground' app
# NOTE: this will restart your app
dokku couchdb:link lolipop playground

# the following environment variables will be set automatically by docker (not
# on the app itself, so they won’t be listed when calling dokku config)
#
#   DOKKU_COUCHDB_LOLIPOP_NAME=/lolipop/DATABASE
#   DOKKU_COUCHDB_LOLIPOP_PORT=tcp://172.17.0.1:5984
#   DOKKU_COUCHDB_LOLIPOP_PORT_5984_TCP=tcp://172.17.0.1:5984
#   DOKKU_COUCHDB_LOLIPOP_PORT_5984_TCP_PROTO=tcp
#   DOKKU_COUCHDB_LOLIPOP_PORT_5984_TCP_PORT=5984
#   DOKKU_COUCHDB_LOLIPOP_PORT_5984_TCP_ADDR=172.17.0.1
#
# and the following will be set on the linked application by default
#
#   COUCHDB_URL=couchdb://lolipop:SOME_PASSWORD@dokku-couchdb-lolipop:5984/lolipop
#
# NOTE: the host exposed here only works internally in docker containers. If
# you want your container to be reachable from outside, you should use `expose`.

# another service can be linked to your app
dokku couchdb:link other_service playground

# since COUCHDB_URL is already in use, another environment variable will be
# generated automatically
#
#   DOKKU_COUCHDB_BLUE_URL=couchdb://other_service:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service

# you can then promote the new service to be the primary one
# NOTE: this will restart your app
dokku couchdb:promote other_service playground

# this will replace COUCHDB_URL with the url from other_service and generate
# another environment variable to hold the previous value if necessary.
# you could end up with the following for example:
#
#   COUCHDB_URL=couchdb://other_service:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service
#   DOKKU_COUCHDB_BLUE_URL=couchdb://other_service:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service
#   DOKKU_COUCHDB_SILVER_URL=couchdb://lolipop:SOME_PASSWORD@dokku-couchdb-lolipop:5984/lolipop

# you can also unlink a couchdb service
# NOTE: this will restart your app and unset related environment variables
dokku couchdb:unlink lolipop playground

# you can tail logs for a particular service
dokku couchdb:logs lolipop
dokku couchdb:logs lolipop -t # to tail

# you can dump the database
dokku couchdb:export lolipop > lolipop.dump

# you can import a dump
dokku couchdb:import lolipop < database.dump

# you can clone an existing database to a new one
dokku couchdb:clone lolipop new_database

# finally, you can destroy the container
dokku couchdb:destroy lolipop
```
