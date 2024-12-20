FROM php:8.0-apache

# Update system
RUN apt-get update

# Install dependencies
RUN apt-get install -y libzip-dev libpng-dev libjpeg-dev unzip wget

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install zip gd

# Enable mod_rewrite for Apache
RUN a2enmod rewrite

RUN chown www-data:www-data /var/www

USER www-data
WORKDIR /var/www
RUN wget https://getgrav.org/download/core/grav-admin/latest -O grav-admin.zip
RUN unzip grav-admin.zip
RUN mv grav-admin html
RUN rm grav-admin.zip
