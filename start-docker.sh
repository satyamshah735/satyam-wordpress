#!/bin/bash

# Enable strict error handling
set -euo pipefail

# Configuration
readonly COMPOSE_FILE="compose.yml"
readonly NETWORK_NAME="my-project-network"
readonly PROJECT_NAME="my-project"

# Check for wp-config.php in the current directory
if [[ ! -f wp-config.php ]]; then
  echo "Error: wp-config.php not found in the current directory." >&2
  exit 1
fi

# Set current GID/UID in environment variables
APPLICATION_GID=$(id -g)
APPLICATION_UID=$(id -u)
export APPLICATION_GID APPLICATION_UID

# Ensure uploads directory exists with correct ownership and permissions
if [[ ! -d uploads ]]; then
  echo "Creating uploads directory..."
  mkdir -p uploads
fi

echo "Setting uploads directory ownership and permissions..."
chown -R "${APPLICATION_UID}:${APPLICATION_GID}" uploads
chmod -R 775 uploads

# Docker Compose command wrapper
COMPOSE_CMD="docker compose --file ${COMPOSE_FILE} --project-name ${PROJECT_NAME}"

# Function to stop and prune Docker containers
stop_docker() {
  echo "Stopping all running Docker containers..."
  docker ps -q | xargs -r docker stop

  echo "Stopping Docker containers..."
  ${COMPOSE_CMD} down --remove-orphans

  echo "Removing dangling Docker resources..."
  docker container prune -f
  docker network prune -f
  docker builder prune -f
  docker image prune -f
  docker volume prune -f
}

start_docker() {
  local detach_param=""

  # Check if detach mode is requested
  if [[ "${1:-}" == "detach" ]]; then
    detach_param="-d"
  fi

  # Create the network for the services
  docker network create "$NETWORK_NAME" >/dev/null 2>&1 || true

  # Build images
  echo "Building Docker images..."
  ${COMPOSE_CMD} build --build-arg APPLICATION_GID="${APPLICATION_GID}" --build-arg APPLICATION_UID="${APPLICATION_UID}"

  # Start services
  echo "Starting Docker containers..."
  ${COMPOSE_CMD} up $detach_param
}

# Check argument
case "${1:-start}" in
"stop")
  stop_docker
  ;;
"restart")
  stop_docker
  start_docker "${2:-}"
  ;;
"start" | "")
  start_docker "${2:-}"
  ;;
*)
  echo "Usage: bash $0 [start|stop|restart] [detach]" >&2
  exit 1
  ;;
esac
