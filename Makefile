.PHONY: up down restart build logs ps pull-all migrate migrate-create seed test

# Start all services in detached mode
up:
	docker compose up -d

# Stop all services
down:
	docker compose down

# Rebuild and restart
restart:
	docker compose down
	docker compose up -d --build

# Build images without starting
build:
	docker compose build

# View logs for all services
logs:
	docker compose logs -f

# 1. RUN THIS FIRST to apply existing migrations
migrate:
	docker compose exec api alembic upgrade head

# 2. RUN THIS SECOND only when you change your models.py
# Usage: make migrate-create msg="your message here"
migrate-create:
	docker compose exec api alembic revision --autogenerate -m "$(msg)"
	docker compose exec api alembic upgrade head

# Check status of containers
ps:
	docker compose ps

# Seed command
seed:
	docker compose exec api python -m app.seeds.default_categories

# Pull the latest code
pull-all:
	cd ../pocketledger-backend && git pull origin main
	cd ../pocketledger-frontend && git pull origin main
	cd ../pocketledger-mobile && git pull origin main
	git pull origin main

# Run tests
test:
	docker compose exec api pytest tests -v
