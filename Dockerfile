FROM gabesullice/drocker-php-fpm

# Install xdebug
RUN pecl install xdebug-beta && docker-php-ext-enable xdebug

COPY ./docroot /var/www/html

RUN chown -R root:www-data /var/www/html

VOLUME /var/www/html
