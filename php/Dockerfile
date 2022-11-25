FROM php:8.1-fpm-alpine as app

# docker-php-ext-install is conveniently provided as part of the official PHP package and allows us to install PHP extensions, we'll need pdo and pdo_mysql
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN set -eux; \
    install-php-extensions pdo pdo_mysql;

#RUN docker-php-ext-install pdo pdo_mysql

# If set to 1, this env disables the warning about running commands as root/super user. 
# It also disables automatic clearing of sudo sessions, 
# so you should really only set this if you use Composer as a 
# super user at all times like in docker containers.
ENV COMPOSER_ALLOW_SUPERUSER=1

# obtain composer using multi-stage build
# https://docs.docker.com/build/building/multi-stage/
COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

# /var/www/html is the default working directory for this image
#WORKDIR '/app'

#Here, we are copying only composer.json and composer.lock (instead of copying the entire source) 
# right before doing composer install. 
# This is enough to take advantage of docker cache and composer install will 
# be executed only when composer.json or composer.lock have indeed changed!- 
# https://medium.com/@softius/faster-docker-builds-with-composer-install-b4d2b15d0fff
COPY ./app/composer.* ./

RUN composer install --prefer-dist --no-dev --no-scripts --no-progress --no-interaction

# One downside to this 👆 is that we have to skip autoload generation and script execution since the source code is not available yet. Easy fix though. This can be done as the last step and it shouldn’t affect the performance anyway.
COPY ./app .

RUN composer dump-autoload --optimize

# Dev image
# This stage is meant to be target-built into a separate image
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target
FROM app AS app_dev

ENV XDEBUG_MODE=off

# COPY --link is a new BuildKit feature which could substantially accelerate your Docker image builds. It works by copying files into independent image layers that don’t rely on the presence of their predecessors. You can add new content to images without the base image even existing on your system.
COPY ./php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN set -eux; \
	install-php-extensions xdebug