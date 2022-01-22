# dokku couchdb [![Build Status](https://img.shields.io/github/workflow/status/dokku/dokku-couchdb/CI/master?style=flat-square "Build Status")](https://github.com/dokku/dokku-couchdb/actions/workflows/ci.yml?query=branch%3Amaster) [![IRC Network](https://img.shields.io/badge/irc-libera-blue.svg?style=flat-square "IRC Libera")](https://webchat.libera.chat/?channels=dokku)

Official couchdb plugin for dokku. Currently defaults to installing [couchdb 3.2.1](https://hub.docker.com/_/couchdb/).

## Requirements

- dokku 0.19.x+
- docker 1.8.x

## Installation

```shell
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-couchdb.git couchdb
```

## Commands

```
couchdb:app-links <app>                            # list all couchdb service links for a given app
couchdb:backup <service> <bucket-name> [--use-iam] # create a backup of the couchdb service to an existing s3 bucket
couchdb:backup-auth <service> <aws-access-key-id> <aws-secret-access-key> <aws-default-region> <aws-signature-version> <endpoint-url> # set up authentication for backups on the couchdb service
couchdb:backup-deauth <service>                    # remove backup authentication for the couchdb service
couchdb:backup-schedule <service> <schedule> <bucket-name> [--use-iam] # schedule a backup of the couchdb service
couchdb:backup-schedule-cat <service>              # cat the contents of the configured backup cronfile for the service
couchdb:backup-set-encryption <service> <passphrase> # set encryption for all future backups of couchdb service
couchdb:backup-unschedule <service>                # unschedule the backup of the couchdb service
couchdb:backup-unset-encryption <service>          # unset encryption for future backups of the couchdb service
couchdb:clone <service> <new-service> [--clone-flags...] # create container <new-name> then copy data from <name> into <new-name>
couchdb:connect <service>                          # connect to the service via the couchdb connection tool
couchdb:create <service> [--create-flags...]       # create a couchdb service
couchdb:destroy <service> [-f|--force]             # delete the couchdb service/data/container if there are no links left
couchdb:enter <service>                            # enter or run a command in a running couchdb service container
couchdb:exists <service>                           # check if the couchdb service exists
couchdb:export <service>                           # export a dump of the couchdb service database
couchdb:expose <service> <ports...>                # expose a couchdb service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)
couchdb:import <service>                           # import a dump into the couchdb service database
couchdb:info <service> [--single-info-flag]        # print the service information
couchdb:link <service> <app> [--link-flags...]     # link the couchdb service to the app
couchdb:linked <service> <app>                     # check if the couchdb service is linked to an app
couchdb:links <service>                            # list all apps linked to the couchdb service
couchdb:list                                       # list all couchdb services
couchdb:logs <service> [-t|--tail] <tail-num-optional> # print the most recent log(s) for this service
couchdb:promote <service> <app>                    # promote service <service> as COUCHDB_URL in <app>
couchdb:restart <service>                          # graceful shutdown and restart of the couchdb service container
couchdb:start <service>                            # start a previously stopped couchdb service
couchdb:stop <service>                             # stop a running couchdb service
couchdb:unexpose <service>                         # unexpose a previously exposed couchdb service
couchdb:unlink <service> <app>                     # unlink the couchdb service from the app
couchdb:upgrade <service> [--upgrade-flags...]     # upgrade service <service> to the specified versions
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to couchdb:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `couchdb:help` command for any undocumented commands.

### Basic Usage

### create a couchdb service

```shell
# usage
dokku couchdb:create <service> [--create-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-m|--memory MEMORY`: container memory limit (default: unlimited)
- `-p|--password PASSWORD`: override the user-level service password
- `-r|--root-password PASSWORD`: override the root-level service password
- `-s|--shm-size SHM_SIZE`: override shared memory size for couchdb docker container

Create a couchdb service named lollipop:

```shell
dokku couchdb:create lollipop
```

You can also specify the image and image version to use for the service. It *must* be compatible with the couchdb image.

```shell
export COUCHDB_IMAGE="couchdb"
export COUCHDB_IMAGE_VERSION="${PLUGIN_IMAGE_VERSION}"
dokku couchdb:create lollipop
```

You can also specify custom environment variables to start the couchdb service in semi-colon separated form.

```shell
export COUCHDB_CUSTOM_ENV="USER=alpha;HOST=beta"
dokku couchdb:create lollipop
```

### print the service information

```shell
# usage
dokku couchdb:info <service> [--single-info-flag]
```

flags:

- `--config-dir`: show the service configuration directory
- `--data-dir`: show the service data directory
- `--dsn`: show the service DSN
- `--exposed-ports`: show service exposed ports
- `--id`: show the service container id
- `--internal-ip`: show the service internal ip
- `--links`: show the service app links
- `--service-root`: show the service root directory
- `--status`: show the service running status
- `--version`: show the service image version

Get connection information as follows:

```shell
dokku couchdb:info lollipop
```

You can also retrieve a specific piece of service info via flags:

```shell
dokku couchdb:info lollipop --config-dir
dokku couchdb:info lollipop --data-dir
dokku couchdb:info lollipop --dsn
dokku couchdb:info lollipop --exposed-ports
dokku couchdb:info lollipop --id
dokku couchdb:info lollipop --internal-ip
dokku couchdb:info lollipop --links
dokku couchdb:info lollipop --service-root
dokku couchdb:info lollipop --status
dokku couchdb:info lollipop --version
```

### list all couchdb services

```shell
# usage
dokku couchdb:list 
```

List all services:

```shell
dokku couchdb:list
```

### print the most recent log(s) for this service

```shell
# usage
dokku couchdb:logs <service> [-t|--tail] <tail-num-optional>
```

flags:

- `-t|--tail [<tail-num>]`: do not stop when end of the logs are reached and wait for additional output

You can tail logs for a particular service:

```shell
dokku couchdb:logs lollipop
```

By default, logs will not be tailed, but you can do this with the --tail flag:

```shell
dokku couchdb:logs lollipop --tail
```

The default tail setting is to show all logs, but an initial count can also be specified:

```shell
dokku couchdb:logs lollipop --tail 5
```

### link the couchdb service to the app

```shell
# usage
dokku couchdb:link <service> <app> [--link-flags...]
```

flags:

- `-a|--alias "BLUE_DATABASE"`: an alternative alias to use for linking to an app via environment variable
- `-q|--querystring "pool=5"`: ampersand delimited querystring arguments to append to the service link

A couchdb service can be linked to a container. This will use native docker links via the docker-options plugin. Here we link it to our `playground` app.

> NOTE: this will restart your app

```shell
dokku couchdb:link lollipop playground
```

The following environment variables will be set automatically by docker (not on the app itself, so they won’t be listed when calling dokku config):

```
DOKKU_COUCHDB_LOLLIPOP_NAME=/lollipop/DATABASE
DOKKU_COUCHDB_LOLLIPOP_PORT=tcp://172.17.0.1:5984
DOKKU_COUCHDB_LOLLIPOP_PORT_5984_TCP=tcp://172.17.0.1:5984
DOKKU_COUCHDB_LOLLIPOP_PORT_5984_TCP_PROTO=tcp
DOKKU_COUCHDB_LOLLIPOP_PORT_5984_TCP_PORT=5984
DOKKU_COUCHDB_LOLLIPOP_PORT_5984_TCP_ADDR=172.17.0.1
```

The following will be set on the linked application by default:

```
COUCHDB_URL=http://lollipop:SOME_PASSWORD@dokku-couchdb-lollipop:5984/lollipop
```

The host exposed here only works internally in docker containers. If you want your container to be reachable from outside, you should use the `expose` subcommand. Another service can be linked to your app:

```shell
dokku couchdb:link other_service playground
```

It is possible to change the protocol for `COUCHDB_URL` by setting the environment variable `COUCHDB_DATABASE_SCHEME` on the app. Doing so will after linking will cause the plugin to think the service is not linked, and we advise you to unlink before proceeding.

```shell
dokku config:set playground COUCHDB_DATABASE_SCHEME=http2
dokku couchdb:link lollipop playground
```

This will cause `COUCHDB_URL` to be set as:

```
http2://lollipop:SOME_PASSWORD@dokku-couchdb-lollipop:5984/lollipop
```

### unlink the couchdb service from the app

```shell
# usage
dokku couchdb:unlink <service> <app>
```

You can unlink a couchdb service:

> NOTE: this will restart your app and unset related environment variables

```shell
dokku couchdb:unlink lollipop playground
```

### Service Lifecycle

The lifecycle of each service can be managed through the following commands:

### connect to the service via the couchdb connection tool

```shell
# usage
dokku couchdb:connect <service>
```

Connect to the service via the couchdb connection tool:

> NOTE: disconnecting from ssh while running this command may leave zombie processes due to moby/moby#9098

```shell
dokku couchdb:connect lollipop
```

### enter or run a command in a running couchdb service container

```shell
# usage
dokku couchdb:enter <service>
```

A bash prompt can be opened against a running service. Filesystem changes will not be saved to disk.

> NOTE: disconnecting from ssh while running this command may leave zombie processes due to moby/moby#9098

```shell
dokku couchdb:enter lollipop
```

You may also run a command directly against the service. Filesystem changes will not be saved to disk.

```shell
dokku couchdb:enter lollipop touch /tmp/test
```

### expose a couchdb service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)

```shell
# usage
dokku couchdb:expose <service> <ports...>
```

Expose the service on the service's normal ports, allowing access to it from the public interface (`0.0.0.0`):

```shell
dokku couchdb:expose lollipop 5984
```

Expose the service on the service's normal ports, with the first on a specified ip adddress (127.0.0.1):

```shell
dokku couchdb:expose lollipop 127.0.0.1:5984
```

### unexpose a previously exposed couchdb service

```shell
# usage
dokku couchdb:unexpose <service>
```

Unexpose the service, removing access to it from the public interface (`0.0.0.0`):

```shell
dokku couchdb:unexpose lollipop
```

### promote service <service> as COUCHDB_URL in <app>

```shell
# usage
dokku couchdb:promote <service> <app>
```

If you have a couchdb service linked to an app and try to link another couchdb service another link environment variable will be generated automatically:

```
DOKKU_COUCHDB_BLUE_URL=http://other_service:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service
```

You can promote the new service to be the primary one:

> NOTE: this will restart your app

```shell
dokku couchdb:promote other_service playground
```

This will replace `COUCHDB_URL` with the url from other_service and generate another environment variable to hold the previous value if necessary. You could end up with the following for example:

```
COUCHDB_URL=http://other_service:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service
DOKKU_COUCHDB_BLUE_URL=http://other_service:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service
DOKKU_COUCHDB_SILVER_URL=http://lollipop:SOME_PASSWORD@dokku-couchdb-lollipop:5984/lollipop
```

### start a previously stopped couchdb service

```shell
# usage
dokku couchdb:start <service>
```

Start the service:

```shell
dokku couchdb:start lollipop
```

### stop a running couchdb service

```shell
# usage
dokku couchdb:stop <service>
```

Stop the service and the running container:

```shell
dokku couchdb:stop lollipop
```

### graceful shutdown and restart of the couchdb service container

```shell
# usage
dokku couchdb:restart <service>
```

Restart the service:

```shell
dokku couchdb:restart lollipop
```

### upgrade service <service> to the specified versions

```shell
# usage
dokku couchdb:upgrade <service> [--upgrade-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-R|--restart-apps "true"`: whether to force an app restart
- `-s|--shm-size SHM_SIZE`: override shared memory size for couchdb docker container

You can upgrade an existing service to a new image or image-version:

```shell
dokku couchdb:upgrade lollipop
```

### Service Automation

Service scripting can be executed using the following commands:

### list all couchdb service links for a given app

```shell
# usage
dokku couchdb:app-links <app>
```

List all couchdb services that are linked to the `playground` app.

```shell
dokku couchdb:app-links playground
```

### create container <new-name> then copy data from <name> into <new-name>

```shell
# usage
dokku couchdb:clone <service> <new-service> [--clone-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-m|--memory MEMORY`: container memory limit (default: unlimited)
- `-p|--password PASSWORD`: override the user-level service password
- `-r|--root-password PASSWORD`: override the root-level service password
- `-s|--shm-size SHM_SIZE`: override shared memory size for couchdb docker container

You can clone an existing service to a new one:

```shell
dokku couchdb:clone lollipop lollipop-2
```

### check if the couchdb service exists

```shell
# usage
dokku couchdb:exists <service>
```

Here we check if the lollipop couchdb service exists.

```shell
dokku couchdb:exists lollipop
```

### check if the couchdb service is linked to an app

```shell
# usage
dokku couchdb:linked <service> <app>
```

Here we check if the lollipop couchdb service is linked to the `playground` app.

```shell
dokku couchdb:linked lollipop playground
```

### list all apps linked to the couchdb service

```shell
# usage
dokku couchdb:links <service>
```

List all apps linked to the `lollipop` couchdb service.

```shell
dokku couchdb:links lollipop
```

### Data Management

The underlying service data can be imported and exported with the following commands:

### import a dump into the couchdb service database

```shell
# usage
dokku couchdb:import <service>
```

Import a datastore dump:

```shell
dokku couchdb:import lollipop < data.dump
```

### export a dump of the couchdb service database

```shell
# usage
dokku couchdb:export <service>
```

By default, datastore output is exported to stdout:

```shell
dokku couchdb:export lollipop
```

You can redirect this output to a file:

```shell
dokku couchdb:export lollipop > data.dump
```

### Backups

Datastore backups are supported via AWS S3 and S3 compatible services like [minio](https://github.com/minio/minio).

You may skip the `backup-auth` step if your dokku install is running within EC2 and has access to the bucket via an IAM profile. In that case, use the `--use-iam` option with the `backup` command.

Backups can be performed using the backup commands:

### set up authentication for backups on the couchdb service

```shell
# usage
dokku couchdb:backup-auth <service> <aws-access-key-id> <aws-secret-access-key> <aws-default-region> <aws-signature-version> <endpoint-url>
```

Setup s3 backup authentication:

```shell
dokku couchdb:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
```

Setup s3 backup authentication with different region:

```shell
dokku couchdb:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION
```

Setup s3 backup authentication with different signature version and endpoint:

```shell
dokku couchdb:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION AWS_SIGNATURE_VERSION ENDPOINT_URL
```

More specific example for minio auth:

```shell
dokku couchdb:backup-auth lollipop MINIO_ACCESS_KEY_ID MINIO_SECRET_ACCESS_KEY us-east-1 s3v4 https://YOURMINIOSERVICE
```

### remove backup authentication for the couchdb service

```shell
# usage
dokku couchdb:backup-deauth <service>
```

Remove s3 authentication:

```shell
dokku couchdb:backup-deauth lollipop
```

### create a backup of the couchdb service to an existing s3 bucket

```shell
# usage
dokku couchdb:backup <service> <bucket-name> [--use-iam]
```

flags:

- `-u|--use-iam`: use the IAM profile associated with the current server

Backup the `lollipop` service to the `my-s3-bucket` bucket on `AWS`:`

```shell
dokku couchdb:backup lollipop my-s3-bucket --use-iam
```

Restore a backup file (assuming it was extracted via `tar -xf backup.tgz`):

```shell
dokku couchdb:import lollipop < backup-folder/export
```

### set encryption for all future backups of couchdb service

```shell
# usage
dokku couchdb:backup-set-encryption <service> <passphrase>
```

Set the GPG-compatible passphrase for encrypting backups for backups:

```shell
dokku couchdb:backup-set-encryption lollipop
```

### unset encryption for future backups of the couchdb service

```shell
# usage
dokku couchdb:backup-unset-encryption <service>
```

Unset the `GPG` encryption passphrase for backups:

```shell
dokku couchdb:backup-unset-encryption lollipop
```

### schedule a backup of the couchdb service

```shell
# usage
dokku couchdb:backup-schedule <service> <schedule> <bucket-name> [--use-iam]
```

flags:

- `-u|--use-iam`: use the IAM profile associated with the current server

Schedule a backup:

> 'schedule' is a crontab expression, eg. "0 3 * * *" for each day at 3am

```shell
dokku couchdb:backup-schedule lollipop "0 3 * * *" my-s3-bucket
```

Schedule a backup and authenticate via iam:

```shell
dokku couchdb:backup-schedule lollipop "0 3 * * *" my-s3-bucket --use-iam
```

### cat the contents of the configured backup cronfile for the service

```shell
# usage
dokku couchdb:backup-schedule-cat <service>
```

Cat the contents of the configured backup cronfile for the service:

```shell
dokku couchdb:backup-schedule-cat lollipop
```

### unschedule the backup of the couchdb service

```shell
# usage
dokku couchdb:backup-unschedule <service>
```

Remove the scheduled backup from cron:

```shell
dokku couchdb:backup-unschedule lollipop
```

### Disabling `docker pull` calls

If you wish to disable the `docker pull` calls that the plugin triggers, you may set the `COUCHDB_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker pull` is disabled.
