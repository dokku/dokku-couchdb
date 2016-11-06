# dokku couchdb (beta) [![Build Status](https://img.shields.io/travis/dokku/dokku-couchdb.svg?branch=master "Build Status")](https://travis-ci.org/dokku/dokku-couchdb) [![IRC Network](https://img.shields.io/badge/irc-freenode-blue.svg "IRC Freenode")](https://webchat.freenode.net/?channels=dokku)

Official CouchDB plugin for dokku. Currently defaults to installing [CouchDB 1.6](https://hub.docker.com/r/frodenas/couchdb/).

## requirements

- dokku 0.4.x+
- docker 1.8.x

## installation

```shell
# on 0.4.x+
sudo dokku plugin:install https://github.com/dokku/dokku-couchdb.git couchdb
```

## commands

```
couchdb:backup <name> <bucket>   Create a backup of the couchdb service to an existing s3 bucket
couchdb:backup-auth <name> <aws_access_key_id> <aws_secret_access_key> Sets up authentication for backups on the couchdb service
couchdb:backup-deauth <name>     Removes backup authentication for the couchdb service
couchdb:backup-schedule <name> <schedule> <bucket> Schedules a backup of the couchdb service
couchdb:backup-unschedule <name> Unschedules the backup of the couchdb service
couchdb:clone <name> <new-name>  Create container <new-name> then copy data from <name> into <new-name>
couchdb:connect <name>           NOT IMPLEMENTED
couchdb:create <name>            Create a couchdb service with environment variables
couchdb:destroy <name>           Delete the service and stop its container if there are no links left
couchdb:enter <name> [command]   Enter or run a command in a running couchdb service container
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
dokku couchdb:create lolipop

# you can also specify custom environment
# variables to start the couchdb service
# in semi-colon separated forma
export COUCHDB_CUSTOM_ENV="USER=alpha;HOST=beta"
dokku couchdb:create lolipop

# get connection information as follows
dokku couchdb:info lolipop

# you can also retrieve a specific piece of service info via flags
dokku couchdb:info lolipop --config-dir
dokku couchdb:info lolipop --data-dir
dokku couchdb:info lolipop --dsn
dokku couchdb:info lolipop --exposed-ports
dokku couchdb:info lolipop --id
dokku couchdb:info lolipop --internal-ip
dokku couchdb:info lolipop --links
dokku couchdb:info lolipop --service-root
dokku couchdb:info lolipop --status
dokku couchdb:info lolipop --version

# a bash prompt can be opened against a running service
# filesystem changes will not be saved to disk
dokku couchdb:enter lolipop

# you may also run a command directly against the service
# filesystem changes will not be saved to disk
dokku couchdb:enter lolipop ls -lah /

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

## Changing database adapter

It's possible to change the protocol for DATABASE_URL by setting
the environment variable COUCHDB_DATABASE_SCHEME on the app:

```
dokku config:set playground COUCHDB_DATABASE_SCHEME=couchdb2
dokku couchdb:link lolipop playground
```

Will cause COUCHDB_URL to be set as
couchdb2://lolipop:SOME_PASSWORD@dokku-couchdb-lolipop:5984/lolipop

CAUTION: Changing COUCHDB_DATABASE_SCHEME after linking will cause dokku to
believe the service is not linked when attempting to use `dokku couchdb:unlink`
or `dokku couchdb:promote`.
You should be able to fix this by

- Changing COUCHDB_URL manually to the new value.

OR

- Set COUCHDB_DATABASE_SCHEME back to its original setting
- Unlink the service
- Change COUCHDB_DATABASE_SCHEME to the desired setting
- Relink the service

## Backups

Datastore backups are supported via AWS S3. The only supported region is `us-east-1`, and using an S3 bucket in another region will result in an error.

>

> If you would like to sponsor work to enable support for other regions, please contact [@josegonzalez](http://github.com/josegonzalez/).

Backups can be performed using the backup commands:

```
# setup s3 backup authentication
dokku couchdb:backup-auth lolipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

# remove s3 authentication
dokku couchdb:backup-deauth lolipop

# backup the `lolipop` service to the `BUCKET_NAME` bucket on AWS
dokku couchdb:backup lolipop BUCKET_NAME

# schedule a backup
dokku couchdb:backup-schedule lolipop CRON_SCHEDULE BUCKET_NAME

# remove the scheduled backup from cron
dokku couchdb:backup-unschedule lolipop
```
