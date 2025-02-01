ARG PHP_VERSION=8.3
ARG DISTRO="alpine"

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}-7.7.17
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG INVOICENINJA_VERSION

ENV INVOICENINJA_VERSION=${INVOICENINJA_VERSION:-"v5.11.34"} \
    INVOICENINJA_REACT_VERSION=${INVOICENINJA_REACT_VERSION:-"05.01.2025.1"} \
    INVOICENINJA_REPO_URL=https://github.com/invoiceninja/invoiceninja \
    INVOICENINJA_REACT_REPO_URL=https://github.com/invoiceninja/ui \
    NGINX_WEBROOT=/www/html \
    NGINX_SITE_ENABLED=invoiceninja \
    SNAPPDF_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PHP_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_BCMATH=TRUE \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_CTYPE=TRUE \
    PHP_ENABLE_EXIF=TRUE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_GD=TRUE \
    PHP_ENABLE_GMP=TRUE \
    PHP_ENABLE_ICONV=TRUE \
    PHP_ENABLE_IGBINARY=TRUE \
    PHP_ENABLE_IMAGICK=TRUE \
    PHP_ENABLE_IMAP=TRUE \
    PHP_ENABLE_INTL=TRUE \
    PHP_ENABLE_MBSTRING=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_SODIUM=TRUE \
    PHP_ENABLE_XML=TRUE \
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
    clone_git_repo "${INVOICENINJA_REPO_URL}" "${INVOICENINJA_VERSION}" /assets/install && \
    \
    npm install && \
    composer install --no-dev --quiet && \
    npm run production && \
    \
    clone_git_repo "${INVOICENINJA_REACT_REPO_URL}" "${INVOICENINJA_REACT_VERSION}" /usr/src/invoiceninja-react && \
    cd /usr/src/invoiceninja-react && \
    npm install && \
    npm run build && \
    cp -r dist/* /assets/install/public/ && \
    mv /assets/install/public/index.html /assets/install/resources/views/react/index.blade.php && \
    \
    chown -R ${NGINX_USER}:${NGINX_GROUP} /assets/install && \
    rm -rf \
            /assets/install/.env.example \
            /assets/install/.env.travis \
            /assets/install/.git \
            /assets/install/docs \
            /assets/install/tests \
            && \
    package remove .invoiceninja-build-deps && \
    package cleanup && \
    rm -rf \
            /root/.cache \
            /root/.composer \
            /root/.npm \
            /var/tmp

COPY install /
