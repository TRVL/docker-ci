FROM php:7.3-cli

# Update package repositories
RUN apt-get update

# Install dependencies
RUN apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libmcrypt-dev \
        libicu-dev \
        libxslt-dev \
        libzip-dev \
        locales \
        gettext-base \
        gettext \
        wget \
        libxpm-dev \
        libvpx-dev \
        unzip

# Install PHP extensions
RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd exif intl xsl json soap dom zip opcache pdo pdo_mysql bcmath pcntl

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin/ --filename=composer

RUN mkdir -p /var/www/.composer \
    && chown www-data:www-data /var/www/.composer
