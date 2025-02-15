# truhponen/grav-cms
# source: https://www.ericjstauffer.com/blog/set-up-local-grav-environment-with-docker-step-by-step-guide
FROM php:8.2-apache

# Update system
RUN apt-get update

# Install dependencies
RUN apt-get install -y libzip-dev libpng-dev libjpeg-dev git wget unzip

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install zip gd

# Enable mod_rewrite for Apache
RUN a2enmod rewrite
