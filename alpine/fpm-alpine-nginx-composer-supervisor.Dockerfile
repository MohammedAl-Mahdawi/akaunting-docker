FROM php:8.1-fpm-alpine3.15

# Arguments defined in docker-compose.yml
ARG AKAUNTING_DOCKERFILE_VERSION=0.1
ARG SUPPORTED_LOCALES="en_US.UTF-8"

ENV NODE_OPTIONS "--max-old-space-size=2048"

RUN apk add --update --no-cache \
    gcc \
    g++ \
    make \
    python2 \
    supervisor \
    vim \
    bash \
    nodejs \
    npm \
    git \
    nginx

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
# Setup Working Dir
WORKDIR /var/www/html
RUN git clone https://github.com/akaunting/akaunting.git . --depth 1
RUN composer install
RUN npm install
RUN npm run dev

COPY akaunting-php-fpm-nginx-supervisord.sh /usr/local/bin/akaunting-php-fpm-nginx-supervisord.sh
COPY html /var/www/html

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/akaunting-php-fpm-nginx-supervisord.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
