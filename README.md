# dokku couchdb [![Build Status](https://img.shields.io/github/actions/workflow/status/dokku/dokku-couchdb/ci.yml?branch=master&style=flat-square "Build Status")](https://github.com/dokku/dokku-couchdb/actions/workflows/ci.yml?query=branch%3Amaster) [![IRC Network](https://img.shields.io/badge/irc-libera-blue.svg?style=flat-square "IRC Libera")](https://webchat.libera.chat/?channels=dokku)

Official couchdb plugin for dokku. Currently defaults to installing [couchdb 3.5.2.1](https://hub.docker.com/_/couchdb/).

## Requirements

- dokku 0.35.x+
- docker 1.8.x

## Installation

```shell
# on 0.35.x+
sudo dokku plugin:install https://github.com/dokku/dokku-couchdb.git --name couchdb
```

## Commands

```
couchdb:app-links [<app>]                          # list all CouchDB service links for a given app
couchdb:backup <service> <bucket-name> [-u|--use-iam] # create a backup of the CouchDB service to an existing s3 bucket
couchdb:backup-auth <service> <aws-access-key-id> <aws-secret-access-key> <aws-default-region> <aws-signature-version> <endpoint-url> # set up authentication for backups on the CouchDB service
couchdb:backup-deauth <service>                    # remove backup authentication for the CouchDB service
couchdb:backup-schedule <service> <schedule> <bucket-name> [-u|--use-iam] # schedule a backup of the CouchDB service
couchdb:backup-schedule-cat <service>              # cat the contents of the configured backup cronfile for the service
couchdb:backup-set-encryption <service> <passphrase> # set encryption for all future backups of CouchDB service
couchdb:backup-set-public-key-encryption <service> <public-key-id> # set GPG Public Key encryption for all future backups of CouchDB service
couchdb:backup-unschedule <service>                # unschedule the backup of the CouchDB service
couchdb:backup-unset-encryption <service>          # unset encryption for future backups of the CouchDB service
couchdb:backup-unset-public-key-encryption <service> # unset GPG Public Key encryption for future backups of the CouchDB service
couchdb:clone <service> <new-service> [--clone-flags...] # create container <new-name> then copy data from <name> into <new-name>
couchdb:create <service> [--create-flags...]       # create a CouchDB service
couchdb:destroy <service> [-f|--force]             # delete the CouchDB service/data/container if there are no links left
couchdb:enter <service>                            # enter or run a command in a running CouchDB service container
couchdb:exists <service>                           # check if the CouchDB service exists
couchdb:export <service>                           # export a dump of the CouchDB service database
couchdb:expose <service> <ports...>                # expose a CouchDB service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)
couchdb:import <service>                           # import a dump into the CouchDB service database
couchdb:info <service> [--info-flags...]           # print the service information
couchdb:link <service> [<app>] [--link-flags...]   # link the CouchDB service to the app
couchdb:linked <service> [<app>]                   # check if the CouchDB service is linked to an app
couchdb:links <service>                            # list all apps linked to the CouchDB service
couchdb:list                                       # list all CouchDB services
couchdb:logs <service> [-t|--tail [<tail-num>]]    # print the most recent log(s) for this service
couchdb:pause <service>                            # pause a running CouchDB service
couchdb:promote <service> [<app>]                  # promote service <service> as COUCHDB_URL in <app>
couchdb:restart <service>                          # graceful shutdown and restart of the CouchDB service container
couchdb:set <service> <key> <value>                # set or clear a property for a service
couchdb:start <service>                            # start a previously stopped CouchDB service
couchdb:stop <service>                             # stop a running CouchDB service
couchdb:unexpose <service>                         # unexpose a previously exposed CouchDB service
couchdb:unlink <service> [<app>] [-n|--no-restart] # unlink the CouchDB service from the app
couchdb:upgrade <service> [--upgrade-flags...]     # upgrade service <service> to the specified versions
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to couchdb:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `couchdb:help` command for any undocumented commands.

### Basic Usage

### create a CouchDB service

```shell
# usage
dokku couchdb:create <service> [--create-flags...]
```

flags:

- `-c|--config-options <string>`: extra arguments to pass to the container create command
- `-C|--custom-env <string>`: semi-colon delimited environment variables to start the service with
- `-i|--image <string>`: the image name to start the service with
- `-I|--image-version <string>`: the image version to start the service with
- `-N|--initial-network <string>`: the initial network to attach the service to
- `-m|--memory <int>`: container memory limit in megabytes (default: unlimited)
- `-p|--password <string>`: override the user-level service password
- `-P|--post-create-network <strings>`: a comma-separated list of networks to attach the service container to after service creation
- `-S|--post-start-network <strings>`: a comma-separated list of networks to attach the service container to after service start
- `-r|--root-password <string>`: override the root-level service password
- `-s|--shm-size <string>`: override shared memory size for the service docker container

Create a couchdb service named lollipop:

```shell
dokku couchdb:create lollipop
```

You can also specify the image and image version to use for the service. It *must* be compatible with the couchdb image.

```shell
export COUCHDB_IMAGE="couchdb"
export COUCHDB_IMAGE_VERSION="3.5.2.1"
dokku couchdb:create lollipop
```

You can also specify custom environment variables to start the couchdb service in semicolon-separated form.

```shell
export COUCHDB_CUSTOM_ENV="USER=alpha;HOST=beta"
dokku couchdb:create lollipop
```

### delete the CouchDB service/data/container if there are no links left

```shell
# usage
dokku couchdb:destroy <service> [-f|--force]
```

flags:

- `-f|--force`: force the destruction of the service

Destroy the service, it's data, and the running container:

```shell
dokku couchdb:destroy lollipop
```

### print the service information

```shell
# usage
dokku couchdb:info <service> [--info-flags...]
```

flags:

- `--config-dir`: show the service configuration directory
- `--data-dir`: show the service data directory
- `--dsn`: show the service DSN
- `--exposed-ports`: show service exposed ports
- `--id`: show the service container id
- `--initial-network`: show the initial network being connected to
- `--internal-ip`: show the service internal ip
- `--links`: show the service app links
- `--post-create-network`: show the networks to attach to after service container creation
- `--post-start-network`: show the networks to attach to after service container start
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
dokku couchdb:info lollipop --initial-network
dokku couchdb:info lollipop --links
dokku couchdb:info lollipop --post-create-network
dokku couchdb:info lollipop --post-start-network
dokku couchdb:info lollipop --service-root
dokku couchdb:info lollipop --status
dokku couchdb:info lollipop --version
```

### list all CouchDB services

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
dokku couchdb:logs <service> [-t|--tail [<tail-num>]]
```

flags:

- `-t|--tail <int>`: tail the logs, optionally showing this many lines

You can tail logs for a particular service:

```shell
dokku couchdb:logs lollipop
```

By default, logs will not be tailed, but you can do this with the --tail flag:

```shell
dokku couchdb:logs lollipop --tail
```

By default the last 100 lines are shown, but a different count can be specified:

```shell
dokku couchdb:logs lollipop --tail=5
```

### link the CouchDB service to the app

```shell
# usage
dokku couchdb:link <service> [<app>] [--link-flags...]
```

flags:

- `-a|--alias <string>`: an alternative alias to use for the config url exported to the app
- `-n|--no-restart`: whether to skip restarting the app
- `-q|--querystring <string>`: ampersand delimited querystring arguments to append to the service url

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
COUCHDB_URL=http://:SOME_PASSWORD@dokku-couchdb-lollipop:5984
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
http2://:SOME_PASSWORD@dokku-couchdb-lollipop:5984
```

### unlink the CouchDB service from the app

```shell
# usage
dokku couchdb:unlink <service> [<app>] [-n|--no-restart]
```

flags:

- `-n|--no-restart`: whether to skip restarting the app

You can unlink a couchdb service:

> NOTE: this will restart your app and unset related environment variables

```shell
dokku couchdb:unlink lollipop playground
```

### set or clear a property for a service

```shell
# usage
dokku couchdb:set <service> <key> <value>
```

Set the network to attach after the service container is started:

```shell
dokku couchdb:set lollipop post-create-network custom-network
```

Set multiple networks:

```shell
dokku couchdb:set lollipop post-create-network custom-network,other-network
```

Unset the post-create-network value:

```shell
dokku couchdb:set lollipop post-create-network
```

Set the keyserver a public key for backup encryption is fetched from:

```shell
dokku couchdb:set lollipop backup-keyserver hkp://keys.example.com
```

### Service Lifecycle

The lifecycle of each service can be managed through the following commands:

### enter or run a command in a running CouchDB service container

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

### expose a CouchDB service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)

```shell
# usage
dokku couchdb:expose <service> <ports...>
```

Expose the service on the service's normal ports, allowing access to it from the public interface (`0.0.0.0`):

```shell
dokku couchdb:expose lollipop 5984
```

Expose the service on the service's normal ports, with the first on a specified ip address (127.0.0.1):

```shell
dokku couchdb:expose lollipop 127.0.0.1:5984
```

### unexpose a previously exposed CouchDB service

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
dokku couchdb:promote <service> [<app>]
```

If you have a couchdb service linked to an app and try to link another couchdb service another link environment variable will be generated automatically:

```
DOKKU_COUCHDB_BLUE_URL=http://:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service
```

You can promote the new service to be the primary one:

> NOTE: this will restart your app

```shell
dokku couchdb:promote other_service playground
```

This will replace `COUCHDB_URL` with the url from other_service and generate another environment variable to hold the previous value if necessary. You could end up with the following for example:

```
COUCHDB_URL=http://:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service
DOKKU_COUCHDB_BLUE_URL=http://:ANOTHER_PASSWORD@dokku-couchdb-other-service:5984/other_service
DOKKU_COUCHDB_SILVER_URL=http://:SOME_PASSWORD@dokku-couchdb-lollipop:5984/lollipop
```

### start a previously stopped CouchDB service

```shell
# usage
dokku couchdb:start <service>
```

Start the service:

```shell
dokku couchdb:start lollipop
```

### stop a running CouchDB service

```shell
# usage
dokku couchdb:stop <service>
```

Stop the service and removes the running container:

```shell
dokku couchdb:stop lollipop
```

### pause a running CouchDB service

```shell
# usage
dokku couchdb:pause <service>
```

Pause the running container for the service:

```shell
dokku couchdb:pause lollipop
```

### graceful shutdown and restart of the CouchDB service container

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

- `-c|--config-options <string>`: extra arguments to pass to the container create command
- `-C|--custom-env <string>`: semi-colon delimited environment variables to start the service with
- `-i|--image <string>`: the image to upgrade the service to
- `-I|--image-version <string>`: the image version to upgrade the service to
- `-N|--initial-network <string>`: the initial network to attach the service to
- `-P|--post-create-network <strings>`: a comma-separated list of networks to attach the service container to after service creation
- `-S|--post-start-network <strings>`: a comma-separated list of networks to attach the service container to after service start
- `-R|--restart-apps`: whether to stop and start the linked apps around the upgrade
- `-s|--shm-size <string>`: override shared memory size for the service docker container

You can upgrade an existing service to a new image or image-version:

```shell
dokku couchdb:upgrade lollipop
```

### Service Automation

Service scripting can be executed using the following commands:

### list all CouchDB service links for a given app

```shell
# usage
dokku couchdb:app-links [<app>]
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

- `-c|--config-options <string>`: extra arguments to pass to the container create command
- `-C|--custom-env <string>`: semi-colon delimited environment variables to start the service with
- `-N|--initial-network <string>`: the initial network to attach the service to
- `-m|--memory <int>`: container memory limit in megabytes (default: unlimited)
- `-p|--password <string>`: override the user-level service password
- `-P|--post-create-network <strings>`: a comma-separated list of networks to attach the service container to after service creation
- `-S|--post-start-network <strings>`: a comma-separated list of networks to attach the service container to after service start
- `-r|--root-password <string>`: override the root-level service password
- `-s|--shm-size <string>`: override shared memory size for the service docker container

You can clone an existing service to a new one:

```shell
dokku couchdb:clone lollipop lollipop-2
```

### check if the CouchDB service exists

```shell
# usage
dokku couchdb:exists <service>
```

Here we check if the lollipop couchdb service exists.

```shell
dokku couchdb:exists lollipop
```

### check if the CouchDB service is linked to an app

```shell
# usage
dokku couchdb:linked <service> [<app>]
```

Here we check if the lollipop couchdb service is linked to the `playground` app.

```shell
dokku couchdb:linked lollipop playground
```

### list all apps linked to the CouchDB service

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

### import a dump into the CouchDB service database

```shell
# usage
dokku couchdb:import <service>
```

Import a datastore dump:

```shell
dokku couchdb:import lollipop < data.dump
```

### export a dump of the CouchDB service database

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

If both passphrase and public key forms of encryption are set, the public key encryption will take precedence.

The underlying core backup script is present [here](https://github.com/dokku/docker-s3backup/blob/main/backup.sh).

Backups can be performed using the backup commands:

### set up authentication for backups on the CouchDB service

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

### remove backup authentication for the CouchDB service

```shell
# usage
dokku couchdb:backup-deauth <service>
```

Remove s3 authentication:

```shell
dokku couchdb:backup-deauth lollipop
```

### create a backup of the CouchDB service to an existing s3 bucket

```shell
# usage
dokku couchdb:backup <service> <bucket-name> [-u|--use-iam]
```

flags:

- `-u|--use-iam`: use the IAM profile associated with the current server

Backup the `lollipop` service to the `my-s3-bucket` bucket on `AWS`:

```shell
dokku couchdb:backup lollipop my-s3-bucket --use-iam
```

Restore a backup file (assuming it was extracted via `tar -xf backup.tgz`):

```shell
dokku couchdb:import lollipop < backup-folder/export
```

### set encryption for all future backups of CouchDB service

```shell
# usage
dokku couchdb:backup-set-encryption <service> <passphrase>
```

Set the GPG-compatible passphrase for encrypting backups for backups:

```shell
dokku couchdb:backup-set-encryption lollipop
```

Public key encryption will take precendence over the passphrase encryption if both types are set.

### set GPG Public Key encryption for all future backups of CouchDB service

```shell
# usage
dokku couchdb:backup-set-public-key-encryption <service> <public-key-id>
```

Set the `GPG` Public Key for encrypting backups:

```shell
dokku couchdb:backup-set-public-key-encryption lollipop
```

The <public-key-id> is fetched from `keyserver.ubuntu.com`, unless the service names another one with the backup-keyserver property:

```shell
dokku couchdb:set lollipop backup-keyserver hkp://keys.example.com
```

### unset encryption for future backups of the CouchDB service

```shell
# usage
dokku couchdb:backup-unset-encryption <service>
```

Unset the `GPG` encryption passphrase for backups:

```shell
dokku couchdb:backup-unset-encryption lollipop
```

### unset GPG Public Key encryption for future backups of the CouchDB service

```shell
# usage
dokku couchdb:backup-unset-public-key-encryption <service>
```

Unset the `GPG` Public Key encryption for backups:

```shell
dokku couchdb:backup-unset-public-key-encryption lollipop
```

### schedule a backup of the CouchDB service

```shell
# usage
dokku couchdb:backup-schedule <service> <schedule> <bucket-name> [-u|--use-iam]
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

### unschedule the backup of the CouchDB service

```shell
# usage
dokku couchdb:backup-unschedule <service>
```

Remove the scheduled backup from cron:

```shell
dokku couchdb:backup-unschedule lollipop
```

### Disabling `docker image pull` calls

If you wish to disable the `docker image pull` calls that the plugin triggers, you may set the `COUCHDB_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker image pull` is disabled.
