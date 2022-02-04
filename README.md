# This repo is for me to play with Akaunting, please refer to the official [Akaunting docker repo](https://github.com/akaunting/docker) if you want stable images.

```shell
# Run Akaunting with FPM on Debian and use Nginx as external proxy
AKAUNTING_SETUP=true COMPOSE_HTTP_TIMEOUT=20000 docker-compose -f fpm-docker-compose.yml up --build

# Run Akaunting using FPM on Alpine and using Nginx as external proxy
AKAUNTING_SETUP=true COMPOSE_HTTP_TIMEOUT=20000 docker-compose -f fpm-docker-compose.yml -f fpm-alpine-docker-compose.yml up --build

# Run Akaunting using FPM on Alpine and using Nginx as external proxy without volumes
# NOTE THE COMMANDS PASSED THROUGH THE COMPOSE FILE `fpm-alpine-no-vol-docker-compose.yml` THEY DO THE SETUP AS WELL!
COMPOSE_HTTP_TIMEOUT=20000 docker-compose -f fpm-docker-compose.yml -f fpm-alpine-no-vol-docker-compose.yml up --build

# Run Akaunting using FPM on Alpine and using Nginx as internal proxy
AKAUNTING_SETUP=true COMPOSE_HTTP_TIMEOUT=20000 docker-compose -f fpm-alpine-nginx-docker-compose.yml up --build

# Download Akaunting using git and install composer and npm and run Akaunting using FPM on Alpine and using Nginx as internal proxy
AKAUNTING_SETUP=true COMPOSE_HTTP_TIMEOUT=20000 docker-compose -f fpm-alpine-nginx-docker-compose.yml -f fpm-alpine-nginx-composer-docker-compose.yml up --build

# Download Akaunting using git and install composer and npm and run Akaunting using FPM and PHP 7.4 on Alpine
docker build -t my-akaunting -f test-with-php7.4-fpm-alpine-composer.Dockerfile .
docker run -it --rm my-akaunting bash

# Download Akaunting using git and install composer and npm and run Akaunting using FPM and PHP 7.3 on Alpine
docker build -t my-akaunting -f test-with-php7.3-fpm-alpine-composer.Dockerfile .
docker run -it --rm my-akaunting bash

# Download Akaunting using git and install composer and npm and run Akaunting using FPM on Alpine and using Nginx as internal proxy and supervisor to manage the queues
AKAUNTING_SETUP=true docker-compose -f fpm-alpine-nginx-docker-compose.yml -f fpm-alpine-nginx-composer-supervisor-docker-compose.yml up --build
```

## License

Akaunting is released under the [GPLv3 license](LICENSE.txt).
