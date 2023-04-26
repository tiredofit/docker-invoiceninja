# github.com/tiredofit/docker-invoiceninja

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-invoiceninja?style=flat-square)](https://github.com/tiredofit/docker-invoiceninja/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-invoiceninja/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-invoiceninja/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/invoiceninja.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/invoiceninja/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/invoiceninja.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/invoiceninja/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build a Docker Image for [Invoice Ninja](https://invoiceninja.org/) - An invoicing tool

* Automatically installs and sets up installation upon first start


## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents


- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Application Settings](#application-settings)
    - [Database Settings](#database-settings)
    - [Mail Settings](#mail-settings)
    - [Performance Settings](#performance-settings)
    - [S3 Settings](#s3-settings)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
*  Requires access to a MySQL/MariaDB Server

## Installation

### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/invoiceninja)

```bash
docker pull docker.io/tiredofdit/invoiceninja:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-invoiceninja/pkgs/container/docker-invoiceninja)

```
docker pull ghcr.io/tiredofit/docker-invoiceninja:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

## Configuration

### Quick Start

- The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

- Set various [environment variables](#environment-variables) to understand the capabilities of this image.
- Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

**The first boot can take from 2 minutes - 5 minutes depending on your CPU to setup the proper schemas.**

- Login to the web server and enter in your admin email address, admin password and start configuring the system!

### Persistent Storage
The following directories are used for configuration and can be mapped for persistent storage.

| Directory                | Description                                                                                                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `/www/logs`              | Invoice Ninja, Nginx and PHP Log files                                                                                   |
| `/assets/custom`         | (Optional) Copy source code over existing source code in /www/html upon container start. Use exact file/folder structure |
| `/assets/custom-scripts` | (Optional) If you want to execute custom scripting, place scripts here with extension `.sh`                              |
| `/www/html`              | (Optional) If you want to expose the invoiceninja sourcecode and enable Self Updating, expose this volume                |
| *OR*                     |                                                                                                                          |
| `/data`                  | Hold onto your persistent sessions and cache between container restarts                                                  |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                         | Description                            |
| ------------------------------------------------------------- | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/)        | Customized Image based on Alpine Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/)           | Nginx webserver                        |
| [PHP-FPM](https://github.com/tiredofit/docker-nginx-php-fpm/) | PHP Interpreter                        |


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
| `ENABLE_SSL_PROXY`        | If using SSL reverse proxy force application to return https URLs `TRUE` or `FALSE`                |                 |         |
| `LANGUAGE`                | What locale/language                                                                               | `en`            |         |
| `LOG_PDF_HTML`            | Log HTML when generating PDF exports                                                               | `FALSE`         |         |
| `OPENEXCHANGE_APP_ID`     | Open Exchange APP ID for currency exchange                                                         |                 |         |
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


### Networking
The following ports are exposed.

| Port | Description |
| ---- | ----------- |
| `80` | HTTP        |

* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <https://invoiceninja.com/>
