#!/bin/bash

set -e

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
WORKDIR="$(dirname $SCRIPT_DIR)"

TAG=latest
BASE_IMAGE_PREFIX=app
REPOSITORY=symfony/$BASE_IMAGE_PREFIX
REMOVE_IMAGE_ON_END=NO
KEEP_SOURCE=NO
PUSH_IMAGE=NO

for i in "$@"; do
case $i in
    --tag=*)
        TAG="${i#*=}"
        shift
    ;;
    --repository=*)
        REPOSITORY="${i#*=}"
        shift
    ;;
    --push)
        PUSH_IMAGE=YES
        shift
    ;;
    --rm)
        REMOVE_IMAGE_ON_END=YES
        shift
    ;;
    --keep-source)
        KEEP_SOURCE=YES
        shift
    ;;
    *)
        # unknown option
    ;;
esac
done

remove_image_if_exists() {
    IMAGE=$1
    if [[ "$(docker images -q $IMAGE 2> /dev/null)" != "" ]]; then
        docker rmi $IMAGE
    fi
}

process_image() {
    IMAGE=$1

    if [ "YES" = "$PUSH_IMAGE" ]; then
        docker push $IMAGE
    fi
    if [ "YES" = "$REMOVE_IMAGE_ON_END" ]; then
        docker rmi $IMAGE
    fi
}

$WORKDIR/.docker/build.sh --prefix=$BASE_IMAGE_PREFIX

# CREATE SOURCE
SOURCE_IMG=app_source:$TAG
SOURCE_VLM=$SCRIPT_DIR/source:/.source
docker build --rm -t $SOURCE_IMG -f $WORKDIR/.dockersource $WORKDIR
docker run --rm -v $SOURCE_VLM $SOURCE_IMG /.source/create.sh $TAG $BASE_IMAGE_PREFIX
docker rmi $SOURCE_IMG

# NGINX
NGINX_IMG=$REPOSITORY-nginx:$TAG
remove_image_if_exists $NGINX_IMG
docker build --rm -t $NGINX_IMG - < $SCRIPT_DIR/source/$TAG/nginx.tar.gz
process_image $NGINX_IMG

# PHP
PHP_IMG=$REPOSITORY-php:$TAG
remove_image_if_exists $PHP_IMG
docker build --rm -t $PHP_IMG - < $SCRIPT_DIR/source/$TAG/php.tar.gz
process_image $PHP_IMG

$WORKDIR/.docker/rmi.sh --prefix=$BASE_IMAGE_PREFIX

# REMOVE SOURCE
if [ "NO" = "$KEEP_SOURCE" ]; then
    docker run --rm -v $SOURCE_VLM cravler/php:8-fpm rm -rf /.source/$TAG
fi