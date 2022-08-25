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
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libmagickwand-dev \
        cron \
        libxml2-dev

# Install docker-php-ext extensions
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install exif
RUN docker-php-ext-install soap
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install intl
RUN docker-php-ext-install gmp
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install gd

# Install and enable PHPRedis
RUN pecl install redis && docker-php-ext-enable redis

# Install and enable imagick
RUN pecl install imagick && docker-php-ext-enable imagick

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
CMD ["php-fpm"]
