# Default target
.DEFAULT_GOAL := help

.PHONY: help check check_episodes npm-install build shell lint lint-vale

DOCKER_STAMP := .docker-image.stamp
DOCKER_DEPS  := Dockerfile docker-compose.yml scripts/build-book.sh package.json package-lock.json

# ---------------------------------------------------------------------------
# HELP SYSTEM
# ---------------------------------------------------------------------------
help:  ## Show this help message
	@echo ""
	@echo "Available Make targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## ' Makefile | sed -E 's/: .*## /\t- /'
	@echo ""

# ---------------------------------------------------------------------------
# CHECKS
# ---------------------------------------------------------------------------
check: check_episodes lint-vale  ## Run all checks (episodes, mp3 files, Vale)

check_episodes:  ## Validate episode list, mp3 list, URL checks, newline normalization
	./scripts/check_episodes.sh

# ---------------------------------------------------------------------------
# LINTING
# ---------------------------------------------------------------------------
lint: lint-vale  ## Run all linters (currently Vale)
spellcheck: lint-vale ## Run Vale style/spell checker inside Docker

lint-vale: lint-vale-error  ## Default: run Vale and show only errors

lint-vale-suggestion: docker-build  ## Vale: show suggestions, warnings, and errors
	docker compose run --rm book-builder \
	  sh -lc 'scripts/lint-vale.sh suggestion'

lint-vale-warning: docker-build  ## Vale: show warnings and errors
	docker compose run --rm book-builder \
	  sh -lc 'scripts/lint-vale.sh warning'

lint-vale-error: docker-build  ## Vale: show only errors
	docker compose run --rm book-builder \
	  sh -lc 'scripts/lint-vale.sh error'

# ---------------------------------------------------------------------------
# DOCKER BUILD
# ---------------------------------------------------------------------------

# High-level target used everywhere (local + CI)
docker-build: $(DOCKER_STAMP)  ## Build the Docker image for the book-builder environment (if needed)

# Stamp file: updated when the image is (re)built
$(DOCKER_STAMP): $(DOCKER_DEPS)
	docker compose build book-builder
	touch $(DOCKER_STAMP)

# ---------------------------------------------------------------------------
# NODE DEPENDENCIES
# ---------------------------------------------------------------------------
npm-install: docker-build  ## Install Node dependencies inside container using node_modules volume
	docker compose run --rm book-builder sh -lc 'if command -v npm >/dev/null 2>&1; then (npm ci || npm install); else echo "npm not found in container"; exit 1; fi'

# ---------------------------------------------------------------------------
# FULL BOOK BUILD
# ---------------------------------------------------------------------------
build: npm-install  ## Build the full HTML, EPUB, PDF output using build-book.sh inside Docker
	docker compose run --rm book-builder

# ---------------------------------------------------------------------------
# INTERACTIVE SHELL
# ---------------------------------------------------------------------------
shell: docker-build  ## Open an interactive shell in the book-builder container
	docker compose run --rm book-builder sh
