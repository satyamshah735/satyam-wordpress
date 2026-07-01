# Use PHP-FPM with Apache as the base image
FROM serversideup/php:8.3.30-fpm-apache

# Build arguments
ARG COMPOSER_ALLOW_SUPERUSER=0
ARG COMPOSER_ROOT_VERSION=1.0.0
ARG HEALTHCHECK_PATH=/wp-json/v1/healthz
ARG SHOW_WELCOME_MESSAGE=false

# Build arguments for dynamic UID/GID from host
ARG APPLICATION_UID=1000
ARG APPLICATION_GID=1000

# Switch to root user to perform system-level operations
USER root

# Install system dependencies
RUN apt update && \
    apt install -y nano bash && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install essential PHP extensions
RUN install-php-extensions gd

# Configure user permissions
RUN docker-php-serversideup-set-id www-data ${APPLICATION_UID}:${APPLICATION_GID} && \
    docker-php-serversideup-set-file-permissions --owner ${APPLICATION_UID}:${APPLICATION_GID} --service apache

# Create and configure Composer cache directory
RUN mkdir -p /composer/cache && chown -R ${APPLICATION_UID}:${APPLICATION_GID} /composer/cache

# Create application directory and set ownership
RUN mkdir -p /var/www/html && \
    chown -R ${APPLICATION_UID}:${APPLICATION_GID} /var/www/html

# Set working directory
WORKDIR /var/www/html

# Copy entrypoint scripts
COPY --chmod=755 --chown=${APPLICATION_UID}:${APPLICATION_GID} ./.docker/dev-server/entrypoint.d/ /etc/entrypoint.d/

# Switch to unprivileged user for security
USER ${APPLICATION_UID}:${APPLICATION_GID}
