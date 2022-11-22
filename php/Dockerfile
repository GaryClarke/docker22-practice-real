FROM php:8.1-fpm-alpine

# docker-php-ext-install is conveniently provided as part of the official PHP package and allows us to install PHP extensions, we'll need pdo and pdo_mysql
RUN docker-php-ext-install pdo pdo_mysql

# If set to 1, this env disables the warning about running commands as root/super user. It also disables automatic clearing of sudo sessions, so you should really only set this if you use Composer as a super user at all times like in docker containers.
ENV COMPOSER_ALLOW_SUPERUSER=1

# obtain composer using multi-stage build
# https://docs.docker.com/build/building/multi-stage/
COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

WORKDIR '/app'

#Here, we are copying only composer.json and composer.lock (instead of copying the entire source) right before doing composer install. This is enough to take advantage of docker cache and composer install will be executed only when composer.json or composer.lock have indeed changed!- https://medium.com/@softius/faster-docker-builds-with-composer-install-b4d2b15d0fff
COPY ./app/composer.* ./

RUN composer install --prefer-dist --no-dev --no-scripts --no-progress --no-interaction

# One downside to this 👆 is that we have to skip autoload generation and script execution since the source code is not available yet. Easy fix though. This can be done as the last step and it shouldn’t affect the performance anyway.
COPY ./app .

RUN composer dump-autoload --optimize