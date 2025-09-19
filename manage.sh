#!/bin/bash
#
# A simple script to manage the Docker Compose stack for OJS.
#
# Usage: ./manage.sh [start|stop|restart|logs|status|update-routes]
#

set -e

# --- Configuration ---
# The base command for all Docker Compose operations.
COMPOSE_CMD="docker compose -f docker-compose.yml"

# --- Functions ---

# Function to update Traefik routes.
update_routes() {
  echo "🔄 Updating Traefik routes..."
  if [ -f ./update-traefik-routes.sh ]; then
      ./update-traefik-routes.sh
  else
      echo "❌ Error: update-traefik-routes.sh script not found."
      exit 1
  fi
}

# Function to display usage information.
usage() {
  echo "Usage: $0 {start|stop|restart|logs|status|update-routes|shell|reset}"
  echo "Commands:"
  echo "  start         - Start the services in the background."
  echo "  stop          - Stop and remove the services."
  echo "  restart       - Restart the services."
  echo "  logs          - View the logs from all services."
  echo "  status        - Show the status of the services."
  echo "  update-routes - Regenerate Traefik routing rules from OJS config."
  echo "  shell         - Open a bash shell inside the 'app' container."
  echo "  reset         - Stop services and delete all persistent data for a fresh install."
  exit 1
}

# --- Main Script ---

# Check if an argument was provided.
if [ -z "$1" ]; then
  usage
fi

ACTION=$1

case "$ACTION" in
  start)
    echo "🚀 Starting services..."
    # Set permissions for volumes. The order is important.
    echo "🔐 Ensuring correct volume permissions (may require sudo)..."
    sudo chown -R 33:33 ./volumes
    sudo chown -R 999:999 ./volumes/db
    # First, ensure the external proxy network exists.
    docker network inspect proxy >/dev/null 2>&1 || {
      echo "🌐 Creating external 'proxy' network..."
      docker network create proxy
    }
    # Start the containers. 'up -d' will create and start them.
    $COMPOSE_CMD up -d
    echo "✅ Services started."
    echo "⏳ Waiting for Traefik to discover services..."
    sleep 5
    # Automatically update routes on start.
    update_routes
    ;;
  stop)
    echo "🛑 Stopping and removing services..."
    # 'down' stops and removes containers, networks, etc.
    $COMPOSE_CMD down
    echo "✅ Services stopped."
    ;;
  restart)
    echo "🔄 Restarting services..."
    $COMPOSE_CMD restart
    echo "✅ Services restarted."
    ;;
  logs)
    echo "📜 Tailing logs... (Press Ctrl+C to exit)"
    $COMPOSE_CMD logs -f
    ;;
  status)
    echo "📊 Checking service status..."
    $COMPOSE_CMD ps
    ;;
  update-routes)
    update_routes
    ;;
  shell)
    echo "🐚 Opening a shell in the 'app' container..."
    $COMPOSE_CMD exec app bash
    ;;
  reset)
    echo "⚠️  WARNING: This will permanently delete all database data and user files."
    read -p "Are you sure you want to continue? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "🛑 Stopping services..."
      $COMPOSE_CMD down
      echo "🔥 Deleting persistent data from ./volumes/ (db, private, public)..."
      # Use find to be safer and avoid deleting the directories themselves or hidden files
      find ./volumes/db -mindepth 1 ! -name 'README.md' -delete
      find ./volumes/private -mindepth 1 -delete
      find ./volumes/public -mindepth 1 -delete
      echo "✅ Data volumes have been reset. You can now run './manage.sh start' for a fresh installation."
    else
      echo "Aborted."
    fi
    ;;
  *)
    echo "❌ Error: Unknown command '$ACTION'"
    usage
    ;;
esac
