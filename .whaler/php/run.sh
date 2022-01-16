#!/bin/bash

# make some dev stuff
if [ -f ./composer.json ]; then
   rm -rf ./var/*
   composer install --no-interaction
fi

@whaler wait 5s
php8-fpm -R