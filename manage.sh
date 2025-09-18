#!/bin/bash
#
# A simple script to manage the Docker Compose stack for OJS.
#
# Usage: ./manage.sh [start|stop|restart|logs|status|update-routes]
#

set -e

# --- Configuration ---
# List of Docker Compose files to use for the Traefik setup.
# This ensures consistency across all commands.
COMPOSE_FILES=(
  -f docker-compose.yml
  -f docker-compose.override.yml
  -f docker-compose.traefik.yml
)

# The base command for all Docker Compose operations.
COMPOSE_CMD="docker compose ${COMPOSE_FILES[*]}"

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
  echo "Usage: $0 {start|stop|restart|logs|status|update-routes}"
  echo "Commands:"
  echo "  start         - Start the services in the background."
  echo "  stop          - Stop and remove the services."
  echo "  restart       - Restart the services."
  echo "  logs          - View the logs from all services."
  echo "  status        - Show the status of the services."
  echo "  update-routes - Regenerate Traefik routing rules from OJS config."
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
    # First, ensure the external proxy network exists.
    docker network inspect proxy >/dev/null 2>&1 || {
      echo "🌐 Creating external 'proxy' network..."
      docker network create proxy
    }
    # Start the containers. 'up -d' will create and start them.
    $COMPOSE_CMD up -d
    echo "✅ Services started."
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
  *)
    echo "❌ Error: Unknown command '$ACTION'"
    usage
    ;;
esac
