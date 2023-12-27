FROM php:8-fpm

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
        cron \
        libxml2-dev \
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

# Laravel Schedule Cron Job
RUN echo "* * * * * root /usr/local/bin/php /var/www/artisan schedule:run >> /dev/null 2>&1"  >> /etc/cron.d/laravel-scheduler
RUN chmod 0644 /etc/cron.d/laravel-scheduler

RUN usermod -u 1000 www-data

WORKDIR /var/www

EXPOSE 9000
CMD ["/usr/bin/supervisord"]
