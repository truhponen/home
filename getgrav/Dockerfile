FROM php:8.0-apache
LABEL maintainer="Tuomo Truhponen (@truhponen)"

# Update system
RUN apt-get update

# Install dependencies
RUN apt-get install -y libzip-dev libpng-dev libjpeg-dev

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install zip gd

# Enable mod_rewrite for Apache
RUN a2enmod rewrite
