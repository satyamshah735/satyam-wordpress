#!/bin/bash

# Enable strict error handling
set -euo pipefail

# Configuration
readonly COMPOSE_FILE="compose.yml"
readonly PROJECT_NAME="my-project"
readonly APP_CONTAINER_NAME="app-server"

# Set current UID in environment variables
APPLICATION_UID=$(id -u)
export APPLICATION_UID

# Login to the app container
docker compose --file "${COMPOSE_FILE}" --project-name "${PROJECT_NAME}" exec --user "${APPLICATION_UID}" "${APP_CONTAINER_NAME}" bash
