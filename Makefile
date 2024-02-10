#--------------------------
# xebro GmbH - nginx-php - 0.0.1
#--------------------------

#RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
## ...and turn them into do-nothing targets
#$(eval $(RUN_ARGS):;@:)

php.composer.install: ## Install composer dependencies
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm composer -o install
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm chmod -R 0777 vendor/
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm chmod -R 0777 var/
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm chmod -R 0777 public/

php.composer.update: ## Update composer dependencies
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm composer -o update
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm chmod -R 0777 vendor/
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm chmod -R 0777 var/
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm chmod -R 0777 public/

php.version: ## Show current php version
	${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm php -v

php.bash: ## Run bash inside the docker container
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm bash

php.test:
ifeq (,$(wildcard ./bin/phpunit))
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm ./bin/phpunit
else
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm phpunit
endif

php.behat:
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm ./vendor/bin/behat

## Execute doctrine migrations
php.migrate:
	@${DOCKER_COMPOSE} ${DOCKER_FILES} run --rm php-fpm ./bin/console doctrine:migrations:migrate -n

## Build prod container
php.build.prod:
	docker build --no-cache --target prod -f "${XEBRO_ROOT_DIR}/docker/php-fpm/Dockerfile" -t "${PROJECT_NAME}_php:${XEBRO_VERSION}" ${XEBRO_ROOT_DIR}/docker/php-fpm/

## Build dev container
php.build.dev:
	@${DOCKER_COMPOSE} ${DOCKER_FILES} build php-fpm

## Output docker logs
php.logs:
	@${DOCKER_COMPOSE} ${DOCKER_FILES} logs -f php-fpm

build: php.build.dev

php.install:
	$(call add_config,".env","docker/php-fpm/.env")

install: php.install
