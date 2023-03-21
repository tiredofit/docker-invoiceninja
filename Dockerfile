ARG PHP_VERSION=8.2
ARG DISTRO="alpine"

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG INVOICENINJA_VERSION

ENV INVOICENINJA_VERSION=${INVOICENINJA_VERSION:-"v5.5.97"} \
    INVOICENINJA_REPO_URL=https://github.com/invoiceninja/invoiceninja \
    NGINX_WEBROOT=/www/html \
    NGINX_SITE_ENABLED=invoiceninja \
    SNAPPDF_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PHP_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_EXIF=TRUE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_GMP=TRUE \
    PHP_ENABLE_ICONV=TRUE \
    PHP_ENABLE_IGBINARY=TRUE \
    PHP_ENABLE_IMAP=TRUE \
    PHP_ENABLE_MBSTRING=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_SODIUM=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    PHP_MEMORY_LIMIT=512M \
    IMAGE_NAME="tiredofit/invoiceninja" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-invoiceninja/"

RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade upgrade && \
    package install .invoiceninja-build-deps \
              git \
              nodejs \
              npm \
              && \
    package install .invoiceninja-run-deps \
              chromium \
              font-isas-misc \
              gnu-libiconv \
              sed \
              ttf-freefont \
              && \
    \
    php-ext enable core && \
    clone_git_repo ${INVOICENINJA_REPO_URL} ${INVOICENINJA_VERSION} /assets/install && \
    npm install --production && \
    npm run production && \
    composer install --no-dev --quiet && \
    chown -R ${NGINX_USER}:${NGINX_GROUP} /assets/install && \
    rm -rf \
        /assets/install/.env.example \
        /assets/install/.env.travis \
        /assets/install/docs \
        /assets/install/tests \
        && \
    package remove .invoiceninja-build-deps && \
    package cleanup && \
    rm -rf /root/.cache \
           /root/.composer \
           /root/.npm \
           /var/tmp

COPY install /
