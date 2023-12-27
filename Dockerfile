FROM php:8.2-fpm

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
        libmemcached-dev \
        libmcrypt-dev \
        libreadline-dev \
        libgmp-dev \
        libzip-dev \
        libz-dev \
        libpq-dev \
        libfreetype6-dev \
        libssl-dev \
        libxml2-dev \
	libmagickwand-dev \
	git \
	supervisor

# Install docker-php-ext extensions
RUN docker-php-ext-install \
	bcmath \
	exif \
	soap \
	pcntl \
	intl \
	gmp \
	zip \
	pdo_mysql \
	sockets \
	gd

# Install and enable PHPRedis
RUN pecl install redis && docker-php-ext-enable redis

# Install xdebug
RUN pecl install xdebug

# Install and enable memcached
RUN pecl install memcached && docker-php-ext-enable memcached

# Install and enable imagick
RUN pecl install imagick && docker-php-ext-enable imagick

RUN usermod -u 1000 www-data

WORKDIR /var/www

EXPOSE 9000
CMD ["php-fpm"]
