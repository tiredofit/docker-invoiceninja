# nfrastack/container-invoiceninja

## About

This repository will build a container image for building [Invoice Ninja](https://www.invoiceninja.org/). An invoicing and billing platform.

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents

* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Installation](#installation)
  * [Prebuilt Images](#prebuilt-images)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
* [Configuration](#configuration)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
  * [Users and Groups](#users-and-groups)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)
* [References](#references)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-invoiceninja/pkgs/container/container-invoiceninja) and [Docker Hub](https://hub.docker.com/r/nfrastack/invoiceninja).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-invoiceninja:(image_tag)
docker.io/nfrastack/invoiceninja:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional phpversion>`

Example:

`docker.io/nfrastack/container-invoiceninja:latest` or

`ghcr.io/nfrastack/container-invoiceninja:1.0-php84`

* `latest` will be the most recent commit

* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest

* There may be an optional `phpversion` if there are mutiple builds using different PHP interpreters you may use those
Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories/files should be mapped for persistent storage in order to utilize the container effectively.

| Directory            | Description           |
| -------------------- | --------------------- |
| `/data`          | Volatile Information      |
| `/logs/invoiceninja` | invoiceninja Logfiles |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                                 | Description         |
| --------------------------------------------------------------------- | ------------------- |
| [OS Base](https://github.com/nfrastack/container-base/)               | Base Image          |
| [Nginx](https://github.com/nfrastack/container-nginx/)                | Nginx Webserver     |
| [Nginx PHP-FPM](https://github.com/nfrastack/container-nginx-php-fpm) | PHP-FPM Interpreter |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Application Settings
| Parameter                 | Description                                                                                        | Default         | `_FILE` |
| ------------------------- | -------------------------------------------------------------------------------------------------- | --------------- | ------- |
| `ADMIN_EMAIL`             | Administrator Email Address - Needed for logging in first boot                                     |                 | x       |
| `ADMIN_PASS`              | Administrator Password - Needed for Logging in                                                     |                 | x       |
| `APP_ENV`                 | Application environment `local` `development` `production`                                         | `production`    | x       |
| `APP_KEY`                 | Application Key if needing to override after a new configuration generation                        |                 |         |
| `APP_NAME`                | Change default application name - Default                                                          | `Invoice Ninja` |         |
| `DISPLAY_ERRORS`          | Display Errors on Website                                                                          | `FALSE`         |         |
| `ENABLE_AUTO_UPDATE`      | If coming from an earlier version of image, automatically update it to latest invoiceninja release | `TRUE`          |         |
| `ENABLE_GOOGLE_MAPS`      | Enable Google Maps                                                                                 | `TRUE`          |         |
| `LANGUAGE`                | What locale/language                                                                               | `en`            |         |
| `LOG_PDF_HTML`            | Log HTML when generating PDF exports                                                               | `FALSE`         |         |
| `OPENEXCHANGE_APP_ID`     | Open Exchange APP ID for currency exchange                                                         |                 |         |
| `REQUIRE_HTTPS`           | If using SSL reverse proxy force application to return https URLs `TRUE` or `FALSE`                |                 |         |
| `SETUP_TYPE`              | Automatically edit configuration after first bootup `AUTO` or `MANUAL`                             | `AUTO`          |         |
| `SITE_URL`                | The url your site listens on example `https://invoiceninja.example.com`                            |                 |         |
| `SESSION_REMEMBER`        | Remember users session                                                                             | `TRUE`          |         |
| `SESSION_LOGOUT_SECONDS`  | Auto logout users after amount of seconds                                                          | `28800`         |         |
| `SESSION_EXPIRE_ON_CLOSE` | Expire session on browser close                                                                    | `FALSE`         |         |


#### Database Settings

| Parameter    | Description                                                     | Default | `_FILE` |
| ------------ | --------------------------------------------------------------- | ------- | ------- |
| `DB_HOST`    | Host or container name of MariaDB Server e.g. `invoiceninja-db` |         | x       |
| `DB_PORT`    | MariaDB Port                                                    | `3306`  | x       |
| `DB_NAME`    | MariaDB Database name e.g. `invoiceninja`                       |         | x       |
| `DB_USER`    | MariaDB Username for above Database e.g. `invoiceninja`         |         | x       |
| `DB_PASS`    | MariaDB Password for above Database e.g. `password`             |         | x       |
| `DB_SSL`     | Enable SSL connectivity to DB_HOST                              | `FALSE` | x       |
| `REDIS_HOST` | Redis Hostname                                                  | `redis` | x       |
| `REDIS_PORT` | Redis Port                                                      | `6379`  | x       |
| `REDIS_PASS` | (optional) Redis Password                                       | `null`  | x       |


#### Mail Settings

| Parameter              | Description                                                                    | Default               | `_FILE` |
| ---------------------- | ------------------------------------------------------------------------------ | --------------------- | ------- |
| `MAIL_TYPE`            | Mail Type                                                                      | `smtp`                |         |
| `MAIL_ERROR_ADDRESS`   | Email this address upon encountering any errors                                |                       |         |
| `MAIL_FROM_NAME`       | Mail from Name                                                                 | `Invoice Ninja`       |         |
| `MAIL_FROM_ADDRESS`    | Mail from Address                                                              | `noreply@example.com` |         |
| `SMTP_HOST`            | SMTP Server to be used to send messages from Postal Management System to users | `postfix-relay`       | x       |
| `SMTP_PORT`            | SMTP Port to be used to send messages from Postal Management System to Users   | `25`                  | x       |
| `SMTP_USER`            | Username to authenticate to SMTP Server                                        | `null`                | x       |
| `SMTP_PASS`            | Password to authenticate to SMTP Server                                        | `null`                | x       |
| `SMTP_ENCRYPTION`      | Type of encryption for SMTP `null` `tls`                                       | `null`                |         |
| `SMTP_TLS_VERIFY_PEER` | Verify TLS certificate before sending                                          | `false`               |         |
| `POSTMARK_SECRET`      | Postmark secret (if using postmark)                                            |                       | x       |

#### Performance Settings

| Parameter           | Description                               | Default    |
| ------------------- | ----------------------------------------- | ---------- |
| `CACHE_DRIVER`      | Cache Driver `file` `redis` `database`    | `file`     |
| `FILESYSTEM_DRIVER` | Filesystem Driver `local` `public`        | `local`    |
| `SESSION_DRIVER`    | Session Driver  `file` `redis` `database` | `database` |
| `QUEUE_CONNECTION`  | Queue Connection  `sync` `file` `redis`   | `file`     |

#### S3 Settings

| Parameter     | Description                                | Default | `_FILE` |
| ------------- | ------------------------------------------ | ------- | ------- |
| `S3_BUCKET`   | S3 Bucket eg `bucket_name`                 |         | x       |
| `S3_ENDPOINT` | S3 Endpoint eg `https://endpoint.com`      |         | x       |
| `S3_KEY`      | S3 Key ID eg `s3_compatible_key`           |         | x       |
| `S3_REGION`   | S3 Region eg `us-east-1`                   |         | x       |
| `S3_SECRET`   | S3 Key Secret eg `a_long_and_glorious_key` |         | x       |
| `S3_URL`      | S3 URL eg `https://endpoint.com`           |         | x       |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

## Support & Maintenance

* For community help, tips, and community discussions, visit the [Discussions board](/discussions).
* For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
* To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
* Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
* Updates are best-effort, with priority given to active production use and support agreements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
