#!/bin/bash

echo "Waiting while mysql starts"
while ! echo exit | nc -z mysql 3306; do
    echo ".";
    sleep 3;
done

if [ ! -d ./sf ]; then

    composer create-project --no-interaction symfony/framework-standard-edition sf/ "2.5.*"
    chmod +x sf/app/console
    cp -R .sf/* sf
    sf/app/console doctrine:database:create

    # Demo page
    sf/app/console generate:bundle --namespace=Hello/WorldBundle --no-interaction --dir=sf/src
    echo 'root:' >> sf/app/config/routing.yml
    echo '    path: /' >> sf/app/config/routing.yml
    echo '    defaults:' >> sf/app/config/routing.yml
    echo '        _controller: FrameworkBundle:Redirect:urlRedirect' >> sf/app/config/routing.yml
    echo '        path: /hello/world' >> sf/app/config/routing.yml
    echo '        permanent: true' >> sf/app/config/routing.yml

else

    composer install --no-interaction --working-dir=sf/

fi

php5-fpm -R