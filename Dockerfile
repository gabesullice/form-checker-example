FROM gabesullice/drocker-php-fpm

COPY ./docroot /var/www/html

VOLUME /var/www/html
