#!/bin/bash

echo "Waiting while mysql starts"
while ! echo exit | nc -z mysql 3306; do
    echo ".";
    sleep 3;
done

if [ ! -d /var/www/sf ]; then

    composer create-project --no-interaction symfony/framework-standard-edition /var/www/sf/ "3.1.*"
    chmod +x /var/www/sf/bin/console
    sed -i 's/database_host: 127.0.0.1/database_host: mysql/g' /var/www/sf/app/config/parameters.yml
    rm -rf /var/www/sf/var/cache/*
    /var/www/sf/bin/console doctrine:database:create

else

    composer install --no-interaction --working-dir=/var/www/sf/

fi

@whaler wait 3s
php7-fpm -R