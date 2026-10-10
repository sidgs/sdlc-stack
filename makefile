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
	@echo "Starting stack..."
	@echo "DOCKER_DEFAULT_PLATFORM: $(DOCKER_DEFAULT_PLATFORM)"
	@echo "GEMINI_API_KEY: $(GEMINI_API_KEY)"
	@echo "OPENAI_API_KEY: $(OPENAI_API_KEY)"
	@echo "ANTHROPIC_API_KEY: $(ANTHROPIC_API_KEY)"
	$(COMPOSE) up -d

stop:
	$(COMPOSE) down

restart:
	$(COMPOSE) down
	$(COMPOSE) up -d
