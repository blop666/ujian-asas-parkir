FROM php:8.2-apache

RUN apt update && apt upgrade -y
RUN apt install -y zip unzip git
RUN docker-php-ext-install pdo_mysql
RUN mkdir -p /web/pino

WORKDIR /web/pino

RUN sed -ri -e 's|/var/www/html|/web/pino/public|g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's|/var/www|/web/pino|g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN sed -ri -e 's|AllowOverride None|AllowOverride All|g' /etc/apache2/apache2.conf

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY . .

RUN chown -R www-data:www-data /web/pino
RUN chmod -R 755 /web/pino/storage /web/pino/bootstrap/cache

RUN a2enmod rewrite