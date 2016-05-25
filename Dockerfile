FROM gabesullice/drocker-php-fpm

COPY ./docroot /var/www/html

RUN chown -R root:www-data /var/www/html

VOLUME /var/www/html
