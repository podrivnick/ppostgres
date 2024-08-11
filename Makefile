DC = docker-compose
STORAGES_FILE = docker_compose/postgres.yaml
STORAGES_FILE_COPY = docker_compose/backup.yaml
EXEC = docker exec -it
DB_CONTAINER = ppostgres.postgres
DB_CONTAINER_COPY = ppostgres.postgres_backup
LOGS = docker logs
ENV_FILE = --env-file .env
ENTER_POSTGRES_CONTAINER = psql -U postgres
DATA_BASE = -d somedatabase

.PHONY: storages
storages:
	${DC} -f ${STORAGES_FILE} -f ${STORAGES_FILE_COPY} ${ENV_FILE} up -d

.PHONY: storages-down
storages-down:
	${DC} -f ${STORAGES_FILE} -f ${STORAGES_FILE_COPY} down

.PHONY: storages-logs
storages-logs:
	${LOGS} ${DB_CONTAINER} -f

.PHONY: dbbash
dbbash:
	${EXEC} ${DB_CONTAINER} ${ENTER_POSTGRES_CONTAINER} ${DATA_BASE}

.PHONY: full_clean
full_clean: ## Stop and remove all Docker containers, volumes, and orphans related to the current docker-compose project
	${DC} down -v --remove-orphans

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
