#!/bin/bash

set -e

TAG=$1
BASE_IMAGE_PREFIX=$2

rm -rf /.source/$TAG
mkdir -p /.source/$TAG

# NGINX
tar --exclude "*.php" -chf /.source/$TAG/nginx.tar -C /usr/src/app public
cat > /tmp/Dockerfile <<- EOM
FROM ${BASE_IMAGE_PREFIX}_nginx:latest
COPY public/ /usr/src/app/public
EOM
tar -uf /.source/$TAG/nginx.tar -C /tmp Dockerfile
gzip /.source/$TAG/nginx.tar

# PHP
find /usr/src/app/public -mindepth 1 ! -name '*.php' -delete
tar -chf /.source/$TAG/php.tar -C /usr/src app
cat > /tmp/Dockerfile <<- EOM
FROM ${BASE_IMAGE_PREFIX}_php:latest
COPY app/ /usr/src/app
EOM
tar -uf /.source/$TAG/php.tar -C /tmp Dockerfile
gzip /.source/$TAG/php.tar