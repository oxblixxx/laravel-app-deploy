FROM php:8.0.2-fpm

# Arguments defined in docker-compose.yml
ARG pelumi
ARG 1000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1000 -d /home/pelumi pelumi
RUN mkdir -p /home/pelumi/.composer && \
    chown -R pelumi:pelumi /home/pelumi

# Set working directory
WORKDIR /var/www

USER pelumi
