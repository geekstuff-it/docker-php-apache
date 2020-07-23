# https://github.com/docker-library/php/blob/86c8ec4d387132b65dbe6c5ab1747f858e03852e/7.4/buster/apache/Dockerfile
ARG PHP_VERSION_TAG=7.4-apache
FROM php:${PHP_VERSION_TAG}

LABEL MAINTAINER="<geekstuff.it>"

# ARGS
ARG PHP_USER_NAME=php
ARG PHP_USER_ID=1000

# ENVs
ENV APACHE_INDEX=index.php \
    APACHE_DOCUMENT_ROOT=/app \
    APACHE_PORT_HTTP=8080 \
    APACHE_SERVER_TOKENS=Minor \
    APACHE_SERVER_SIGNATURE=On \
    TZ=UTC

# Create php user and /app folder
RUN set -eux; \
	addgroup --gid ${PHP_USER_ID} ${PHP_USER_NAME} \
 &&	adduser --uid ${PHP_USER_ID} --gid ${PHP_USER_ID} --disabled-password --disabled-login --gecos ${PHP_USER_NAME} ${PHP_USER_NAME} \
 && mkdir -p /app \
 && chown ${PHP_USER_NAME}: /app

# Common packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -yq \
    tzdata \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Apache
COPY vhost.conf /etc/apache2/sites-available/default.conf
RUN rm /etc/apache2/sites-available/000-default.conf \
 && a2enmod rewrite \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
 && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
 && sed -ri -e 's/^Listen 80$/Listen ${APACHE_PORT_HTTP}/g' /etc/apache2/ports.conf \
 && sed -ri -e 's/^ServerTokens .*/ServerTokens ${APACHE_SERVER_TOKENS}/g' /etc/apache2/conf-available/security.conf \
 && sed -ri -e 's/^ServerSignature .*/ServerSignature ${APACHE_SERVER_SIGNATURE}/g' /etc/apache2/conf-available/security.conf

# PHP
COPY php.ini /usr/local/etc/php/conf.d/php.ini

## Extensions

### Common and their dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure intl \
 && docker-php-ext-install intl \
 && docker-php-ext-install json \
 && docker-php-ext-install pcntl \
 && docker-php-ext-install zip

# Letting extensions of this box switch to this user if they want to
# USER ${PHP_USER_NAME}

WORKDIR /app
