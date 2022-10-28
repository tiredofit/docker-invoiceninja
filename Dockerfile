FROM docker.io/tiredofit/nginx-php-fpm:8.1
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV INVOICENINJA_VERSION=v5.5.35 \
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
    apk update && \
    apk upgrade && \
    apk add -t .invoiceninja-build-deps \
              git \
              nodejs \
              npm \
              && \
    apk add -t .invoiceninja-run-deps \
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
    rm -rf /root/.composer && \
    apk del .invoiceninja-build-deps && \
    rm -rf /var/tmp/* /var/cache/apk/* && \
    rm -rf /root/.npm /root/.cache

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Assets
ADD install /
