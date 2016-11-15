#!/bin/bash

cd /var/www
composer install
php artisan config:cache
php artisan migrate
php artisan key:generate
php artisan config:cache
php artisan db:seed
php artisan config:cache