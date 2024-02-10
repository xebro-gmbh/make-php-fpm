FROM php:8.2-fpm-bullseye as prod

MAINTAINER Daniel Langemann <daniel@xebro.de>

ARG XEBRO_VERSION

LABEL de.xebro.version=$XEBRO_VERSION

ENV USER_GID 1000
ENV USER_UID 1000
ENV BASE_VERSION=$XEBRO_VERSION
ENV HISTFILE /var/www/html/.bash_history
ENV PHP_IDE_CONFIG "serverName=dev.local"

ENV WORKING_DIR="/var/www/html"
RUN mkdir -p ${WORKING_DIR} ;

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean -y

# Download script to install PHP extensions and dependencies
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      curl \
      git \
      rsync \
      zip \
      unzip \
      gosu \
    && install-php-extensions \
#     ldap \
#     memcached \
#     redis \
      bcmath \
      bz2 \
      calendar \
      exif \
      gd \
      intl \
      mysqli \
      opcache \
      pdo_mysql \
      soap \
      sockets \
      xsl \
      mongodb \
      zip \
      && pecl install apcu \
	  && docker-php-ext-enable apcu \
      && pecl clear-cache \

RUN echo $XEBRO_VERSION > /var/VERSION
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
ADD ./etc/php.ini "$PHP_INI_DIR/conf.d/xxx-prod-php.ini"
ADD ./etc/entrypoint.sh /docker-entrypoint.d/

RUN chown -R www-data:www-data /var/www/html ; \
    chmod -R 0777 /var/www/html/

ENTRYPOINT ["/docker-entrypoint.d/entrypoint.sh"]

EXPOSE 9000
WORKDIR ${WORKING_DIR}

FROM prod as dev

ENV COMPOSER_HOME /composer_data
ENV COMPOSER_CACHE_DIR /composer
ENV XDEBUG_MODE debug

RUN mkdir -p ${COMPOSER_HOME} ; \
    mkdir -p ${COMPOSER_CACHE_DIR}

RUN apt-get update && apt-get -y install \
    wget \
    vim \
    make

RUN install-php-extensions xdebug

COPY ./etc/install_composer.sh /var/scripts/
RUN /var/scripts/install_composer.sh
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN chmod -R 0777 ${COMPOSER_HOME}
ADD ./etc/php-dev.ini "${PHP_INI_DIR}/conf.d/zzz-dev-php.ini"
