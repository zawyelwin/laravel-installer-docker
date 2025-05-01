FROM php:8.3-cli-alpine

# Laravel installer version
ARG INSTALLER_VERSION="5.8.3"

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk --update --no-cache add \
    unzip \
    libpq-dev \
    bash \
    zip \
    git \
    nodejs \
    npm \
    && docker-php-ext-install pdo_mysql pdo_pgsql

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

VOLUME ["/composer/cache"]

# Set Composer home to use the cache volume
ENV COMPOSER_CACHE_DIR=/composer/cache

# Install Laravel installer
RUN composer global require laravel/installer:${INSTALLER_VERSION} --with-all-dependencies \
    && composer clear-cache

# Add composer bin to PATH
ENV PATH=/root/.composer/vendor/bin:$PATH

# Clean up
RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Set the entrypoint to laravel
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]