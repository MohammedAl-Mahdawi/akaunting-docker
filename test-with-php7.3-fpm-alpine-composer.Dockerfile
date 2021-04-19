FROM php:7.3-fpm-alpine3.12

# Add Repositories
RUN rm -f /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories

# Add Dependencies
RUN apk add --update --no-cache \
    gcc \
    g++ \
    make \
    python2 \
    nano \
    bash \
    nodejs \
    npm \
    git \
    zip

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install PHP Extensions
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions gd zip bcmath

# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

# Download Akaunting application
RUN mkdir -p /var/www/html
RUN cd /var/www/html && git clone --depth=1 --branch=master https://github.com/akaunting/akaunting.git .

# Setup Working Dir
WORKDIR /var/www/html

RUN cp /var/www/html/.env.testing /var/www/html/.env
