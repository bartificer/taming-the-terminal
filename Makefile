# Makefile for Taming the Terminal book tooling

.PHONY: check check_episodes docker-build build

# Run the episode consistency checks
check: check_episodes

check_episodes:
	./scripts/check_episodes.sh

# Build the Docker image (book-builder service)
docker-build:
	docker compose build book-builder

# Build the book using Docker (HTML, EPUB, PDFs, etc.)
build: docker-build
	docker compose run --rm book-builder
