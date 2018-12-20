FROM php:7.2-cli

# Update package repositories
RUN apt-get update

# Install php dependencies
RUN apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libicu-dev \
        libxslt-dev \
        locales \
        gettext-base \
        gettext \
        libxpm-dev \
        libvpx-dev

# Install PHP extensions
RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
        --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
        --with-xpm-dir=/usr/lib/x86_64-linux-gnu/ \
--with-vpx-dir=/usr/lib/x86_64-linux-gnu/
RUN docker-php-ext-install gd exif intl xsl json soap dom zip opcache pdo pdo_mysql bcmath pcntl

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN mkdir -p /var/www/.composer \
&& chown www-data:www-data /var/www/.composer
