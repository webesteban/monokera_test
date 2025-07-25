#!/bin/bash
set -e

SERVICES=("order_service" "customer_service")

function build() {
  echo "📦 Building containers..."
  docker-compose --env-file .env build
}

function up() {
  echo "🚀 Starting services..."
  docker-compose --env-file .env up -d
}

function migrate {
  for service in "${SERVICES[@]}"; do
    echo "📦 Migrating $service..."
    docker-compose exec "$service" bash -c "rails db:create db:migrate"
  done
}

function seed {
  for service in "${SERVICES[@]}"; do
    if [ "$service" == "customer_service" ]; then
      echo "🌱 Seeding $service..."
      docker-compose exec "$service" bash -c "rails db:seed"
    fi
  done
}

function test() {
  echo "🧪 Running tests..."
  for service in "${SERVICES[@]}"; do
    echo "➡️ Testing $service..."
    docker-compose exec "$service" bash -c "rspec"
  done
}

function logs() {
  echo "📜 Streaming logs..."
  docker-compose logs -f
}

function restart() {
  echo "🔁 Restarting services..."
  docker-compose down
  docker-compose --env-file .env up -d
}

function down() {
  echo "🧹 Stopping and removing containers..."
  docker-compose down -v --remove-orphans
}

function reset() {
  down
  echo "♻️ Pruning Docker system..."
  docker system prune -f
}

function status() {
  docker-compose ps
}

case "$1" in
  build) build ;;
  up) up ;;
  migrate) migrate ;;
  seed) seed ;;
  test) test ;;
  logs) logs ;;
  restart) restart ;;
  down) down ;;
  reset) reset ;;
  status) status ;;
  *)
    echo "❓ Invalid command: $1"
    echo "Usage: ./run.sh [build|up|migrate|seed|test|logs|restart|down|reset|status]"
    exit 1
    ;;
esac
