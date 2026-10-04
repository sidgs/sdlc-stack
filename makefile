COMPOSE := env -u DOCKER_DEFAULT_PLATFORM docker compose -f sdlc-stacks.yaml

.DEFAULT_GOAL := usage

.PHONY: usage start stop restart

usage:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  start    Start redis, pgvector, mailpit, litellm, s3, and gcs"
	@echo "  stop     Stop the stack"
	@echo "  restart  Restart the stack"
	@echo "  usage    Show this help"

start:
	$(COMPOSE) up -d

stop:
	$(COMPOSE) down

restart:
	$(COMPOSE) down
	$(COMPOSE) up -d
