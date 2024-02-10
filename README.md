xebro Makefile - php-fpm
======

This is the php-fpm bundle for the [xebro Makefile](https://github.com/xebro-gmbh/make-core) project.

## Prerequisite
This bundle could be used standalone or for your cli php scripts or as part of a "web" bundle to host you website.

### Install

#### Solo install
```bash
make docker/php-fpm
```

#### Webserver install

```bash
make docker/traefik
make docker/nginx-php
make docker/php-fpm
```

There are more aditional bundles, like `docker/mailcatcher` or `docker/mariadb` for example.