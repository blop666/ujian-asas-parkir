FROM php:8.2-apache

RUN apt update && apt upgrade -y
RUN apt install -y zip unzip git
RUN docker-php-ext-install pdo_mysql

RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .


RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache