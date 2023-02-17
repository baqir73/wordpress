FROM ubuntu:20.04

# Set the geographical location
RUN ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# Set the timezone
ENV TZ=America/New_York

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nginx mysql-server mysql-client php-fpm php-mysql wget

RUN service mysql start && mysql -u root -e "CREATE DATABASE WordPress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; Create User 'user'@'localhost' identified by 'user'; GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost'; Flush Privileges;"

# Copy the WordPress application
COPY school-of-excellence/app/public /var/www/html/wordpress

RUN chown -R www-data:www-data /var/www/html/wordpress

RUN chmod -R 755 /var/www/html/wordpress

RUN mkdir /var/www/html/wordpress/wp-content/uploads

RUN chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads

# Copy nginx config files
COPY school-of-excellence/conf/nginx/nginx.conf.hbs /etc/nginx/nginx.conf
COPY school-of-excellence/conf/nginx/site.conf.hbs /etc/nginx/site.conf
COPY school-of-excellence/conf/nginx/includes/gzip.conf.hbs /etc/nginx/includes/gzip.conf
COPY school-of-excellence/conf/nginx/includes/mime-types.conf.hbs /etc/nginx/includes/mime-types.conf
COPY school-of-excellence/conf/nginx/includes/restrictions.conf.hbs /etc/nginx/includes/restrictions.conf
COPY school-of-excellence/conf/nginx/includes/wordpress-multi.conf.hbs /etc/nginx/includes/wordpress-multi.conf
COPY school-of-excellence/conf/nginx/includes/wordpress-single.conf.hbs /etc/nginx/includes/wordpress-single.conf

# Copy php-fpm config files
COPY school-of-excellence/conf/php/php-fpm.conf.hbs /etc/php/7.4/fpm/php-fpm.conf
COPY school-of-excellence/conf/php/php.ini.hbs /etc/php/7.4/fpm/php.ini
COPY school-of-excellence/conf/php/php-fpm.d/www.conf.hbs /etc/php/7.4/fpm/pool.d/www.conf

# Copy the startup script
 COPY start.sh /start.sh

# Set the startup script as executable
 RUN chmod +x /start.sh
