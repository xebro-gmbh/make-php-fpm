xebro Makefile - php-fpm
======

This is the php-fpm bundle for the [xebro Makefile](https://github.com/xebro-gmbh/make-core) project.

## Prerequisite
This bundle could be used standalone or for your cli php scripts or as part of a "web" bundle to host you website.

### Install

#### Solo install
```bash
composer require xebro-gmbh/make-php-fpm
```

#### Webserver install

```bash
composer require xebro-gmbh/make-traefik
composer require xebro-gmbh/make-nginx-php
composer require xebro-gmbh/make-php-fpm
```

There are more aditional bundles, like `xebro-gmbh/make-mailcatcher` or `xebro-gmbh/make-mariadb` for example.
