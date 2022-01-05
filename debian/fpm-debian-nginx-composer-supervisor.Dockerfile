FROM php:7.4.27-fpm

# Arguments defined in docker-compose.yml
ARG AKAUNTING_DOCKERFILE_VERSION=0.1
ARG SUPPORTED_LOCALES="en_US.UTF-8"

RUN apt-get update \
 && apt-get -y upgrade --no-install-recommends \
 && apt-get install -y \
    build-essential \
    imagemagick \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libssl-dev \
    libxml2-dev \
    libxrender1 \
    libzip-dev \
    locales \
    openssl \
    unzip \
    zip \
    zlib1g-dev \
    supervisor \
    vim \
    bash \
    nodejs \
    npm \
    git \
    nginx \
    --no-install-recommends \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install PHP Extensions
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions gd zip intl imap xsl pgsql opcache bcmath mysqli pdo_mysql redis pcntl

# Configure Extension
RUN docker-php-ext-configure \
    opcache --enable-opcache

# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

# Clear npm proxy
RUN npm config rm proxy
RUN npm config rm https-proxy

# Download Akaunting application
RUN rm -rf /var/www/html
RUN mkdir -p /var/www/html
RUN cd /var/www/html && git clone https://github.com/akaunting/akaunting.git . --depth 1 && composer install && npm install && npm run dev

COPY akaunting-php-fpm-nginx-supervisord.sh /usr/local/bin/akaunting-php-fpm-nginx-supervisord.sh
COPY html /var/www/html

RUN chmod -R u=rwX,g=rX,o=rX /var/www/html
RUN chown -R www-data:root /var/www/html

# Setup Working Dir
WORKDIR /var/www/html

USER root

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/akaunting-php-fpm-nginx-supervisord.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
