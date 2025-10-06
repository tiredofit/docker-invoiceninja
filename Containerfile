# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="Invoice Ninja" \
        org.opencontainers.image.description="Containerized Invoicing and Billing platform" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/wordpress" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-wordpress/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-wordpress.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    INVOICENINJA_VERSION="v5.12.16" \
    INVOICENINJA_REACT_VERSION="18.07.2025.1" \
    INVOICENINJA_REPO_URL=https://github.com/invoiceninja/invoiceninja \
    INVOICENINJA_REACT_REPO_URL=https://github.com/invoiceninja/ui

ENV \
    NGINX_WEBROOT=/www/html \
    NGINX_SITE_ENABLED=invoiceninja \
    SNAPPDF_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PHP_CREATE_SAMPLE_PHP=FALSE \
    PHP_MODULE_BCMATH=TRUE \
    PHP_MODULE_CURL=TRUE \
    PHP_MODULE_CTYPE=TRUE \
    PHP_MODULE_EXIF=TRUE \
    PHP_MODULE_FILEINFO=TRUE \
    PHP_MODULE_GD=TRUE \
    PHP_MODULE_GMP=TRUE \
    PHP_MODULE_ICONV=TRUE \
    PHP_MODULE_IGBINARY=TRUE \
    PHP_MODULE_IMAGICK=TRUE \
    PHP_MODULE_IMAP=TRUE \
    PHP_MODULE_INTL=TRUE \
    PHP_MODULE_MBSTRING=TRUE \
    PHP_MODULE_OPENSSL=TRUE \
    PHP_MODULE_SODIUM=TRUE \
    PHP_MODULE_XML=TRUE \
    PHP_MODULE_TOKENIZER=TRUE \
    PHP_MODULE_ZIP=TRUE \
    PHP_MEMORY_LIMIT=512M \
    IMAGE_NAME="nfrastack/invoiceninja" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-invoiceninja/"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

RUN echo "" && \
    INVOICENINJA_BUILD_DEPS=" \
                                git \
                                nodejs \
                                npm \
                            " \
                            && \
    \
    INVOICENINJA_RUN_DEPS=" \
                                chromium \
                                font-isas-misc \
                                gnu-libiconv \
                                sed \
                                ttf-freefont \
                          " \
                          && \
    \
    source /container/base/functions/container/build && \
    container_build_log image && \
    package update && \
    package upgrade && \
    package install \
                        WORDPRESS_RUN_DEPS \
                    && \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    clone_git_repo "${INVOICENINJA_REPO_URL}" "${INVOICENINJA_VERSION}" /container/data/invoiceninja/install && \
    \
    npm install && \
    composer install --no-dev --quiet && \
    npm run production && \
    \
    clone_git_repo "${INVOICENINJA_REACT_REPO_URL}" "${INVOICENINJA_REACT_VERSION}" /usr/src/invoiceninja-react && \
    cd /usr/src/invoiceninja-react && \
    npm install && \
    npm run build && \
    cp -r dist/* /container/data/invoiceninja/install/public/ && \
    mv /container/data/invoiceninja/install/public/index.html /container/data/invoiceninja/install/resources/views/react/index.blade.php && \
    \
    chown -R "${NGINX_USER}":"${NGINX_GROUP}" /container/data/invoiceninja/install && \
    rm -rf \
            /container/data/invoiceninja/install/.env.example \
            /container/data/invoiceninja/install/.env.travis \
            /container/data/invoiceninja/install/.git \
            /container/data/invoiceninja/install/docs \
            /container/data/invoiceninja/install/tests \
            && \
    package remove \
                    INVOICENINJA_BUILD_DEPS \
                    && \
    package cleanup


COPY rootfs /

ARG PHP_VERSION=8.3
ARG DISTRO="alpine"

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}-7.7.19
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG INVOICENINJA_VERSION

ENV INVOICENINJA_VERSION=${INVOICENINJA_VERSION:-"v5.12.16"} \
    INVOICENINJA_REACT_VERSION=${INVOICENINJA_REACT_VERSION:-"18.07.2025.1"} \
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
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    clone_git_repo "${INVOICENINJA_REPO_URL}" "${INVOICENINJA_VERSION}" /container/data/invoiceninja/install/ && \
    \
    npm install && \
    composer install --no-dev --quiet && \
    npm run production && \
    \
    clone_git_repo "${INVOICENINJA_REACT_REPO_URL}" "${INVOICENINJA_REACT_VERSION}" /usr/src/invoiceninja-react && \
    cd /usr/src/invoiceninja-react && \
    npm install && \
    npm run build && \
    cp -r dist/* /container/data/invoiceninja/install/public/ && \
    mv /container/data/invoiceninja/install/public/index.html /container/data/invoiceninja/install/resources/views/react/index.blade.php && \
    \
    chown -R ${NGINX_USER}:${NGINX_GROUP} /container/data/invoiceninja/install && \
    rm -rf \
            /container/data/invoiceninja/install/.env.example \
            /container/data/invoiceninja/install/.env.travis \
            /container/data/invoiceninja/install/.git \
            /container/data/invoiceninja/install/docs \
            /container/data/invoiceninja/install/tests \
            && \
    container_build_log add "Invoice Ninja" "${INVOICENINJA_VERSION}" "${INVOICENINJA_REPO_URL}" && \
    container_build_log add "Invoice Ninja UI" "${INVOICENINJA_REACT_VERSION}" "${INVOICENINJA_REACT_REPO_URL}" && \
    package remove \
                    INVOICENINJA_BUILD_DEPS \
                    && \
    package cleanup

COPY install /
