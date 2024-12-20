# truhponen/getgrav
# Official PHP image
FROM php:8.2-apache

# Update system
RUN apt-get update

# Install dependencies
RUN apt-get install -y libzip-dev libpng-dev libjpeg-dev unzip wget rsync

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install zip gd

# Enable mod_rewrite for Apache
RUN a2enmod rewrite

# Give www-data user rights to all www folders
RUN chown www-data:www-data /var/www

# Download, unzip and copy Grav files to html-folder
USER www-data
WORKDIR /var/www/html
RUN wget https://getgrav.org/download/skeletons/learn2-with-git-sync-site/1.6.8 -O grav.zip 
RUN unzip grav.zip

# Not needed as there is no folder in zip-file
#RUN rsync -r /var/www/grav-admin/* /var/www/html

# Remove grav-admin.zip file
RUN rm grav.zip

# Not needed - Remove grav-admin folder
#RUN rm -r grav-admin

# Place for volume inside container for data persistence
VOLUME ["/var/www/html"]
