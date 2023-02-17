#!/bin/bash

service mysql start


# Start PHP-FPM
service php7.4-fpm start

# Start Nginx
service nginx start


# Keep the container running
tail -f /dev/null