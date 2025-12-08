# Default target
.DEFAULT_GOAL := help

.PHONY: help check check_episodes docker-build npm-install build shell

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
check: check_episodes  ## Run all checks (episodes, mp3 files, etc.)
check_episodes:  ## Validate episode list, mp3 list, URL checks, newline normalization
	./scripts/check_episodes.sh

# ---------------------------------------------------------------------------
# DOCKER BUILD
# ---------------------------------------------------------------------------
docker-build:  ## Build the Docker image for the book-builder environment
	docker compose build book-builder

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
