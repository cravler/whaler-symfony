#!/bin/bash

echo "Waiting while mysql starts"
while ! echo exit | nc -z mysql 3306; do
    echo ".";
    sleep 3;
done

if [ ! -d /var/www/sf ]; then

    composer create-project --no-interaction symfony/framework-standard-edition /var/www/sf/ "2.5.*"
    chmod +x /var/www/sf/app/console
    cp -R /var/www/.mcloud/php/sf/* /var/www/sf
    /var/www/sf/app/console doctrine:database:create

    # Demo page
    /var/www/sf/app/console generate:bundle --namespace=Hello/WorldBundle --no-interaction --dir=/var/www/sf/src
    echo 'root:' >> /var/www/sf/app/config/routing.yml
    echo '    path: /' >> /var/www/sf/app/config/routing.yml
    echo '    defaults:' >> /var/www/sf/app/config/routing.yml
    echo '        _controller: FrameworkBundle:Redirect:urlRedirect' >> /var/www/sf/app/config/routing.yml
    echo '        path: /hello/world' >> /var/www/sf/app/config/routing.yml
    echo '        permanent: true' >> /var/www/sf/app/config/routing.yml

else

    composer install --no-interaction --working-dir=/var/www/sf/

fi

php5-fpm -R