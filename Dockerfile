FROM php:8.2-fpm

ARG NODE_MAJOR=21

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
	ca-certificates \
	curl \
	gnupg


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

# Install nodejs
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" > /etc/apt/sources.list.d/nodesource.list

RUN apt update && apt install -y nodejs

RUN usermod -u 1000 www-data

WORKDIR /var/www

EXPOSE 9000
CMD ["php-fpm"]
