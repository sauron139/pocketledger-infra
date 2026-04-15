.PHONY: up down restart build logs ps pull-all

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

# Run alembic migration
migrate:
	docker compose exec api alembic revision --autogenerate -m "add composite indexes, recurring transactions, notifications, audit logs"
	docker compose exec api alembic upgrade head

# Check status of containers
ps:
	docker compose ps

# Seed command: populate db with initial data

seed:
	docker compose exec api python -m app.seeds.default_categories

# Pull the latest code for all application repos (Handy for polyrepos!)
pull-all:
	cd ../pocketledger-backend && git pull origin main
	cd ../pocketledger-frontend && git pull origin main
	cd ../pocketledger-mobile && git pull origin main
	git pull origin main

# Add this to initiate test
test:
	docker compose exec api pytest tests -v
