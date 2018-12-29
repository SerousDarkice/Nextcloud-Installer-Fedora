#!/bin/bash

echo "#######"
echo "Welcome to the Nextcloud MariaDB configuration script!"
echo "#######"

# Create variables

echo "Enter a database name."
read dbname
echo "Enter a database username."
read dbuser
echo "Enter a password for the database user: $dbuser"
read dbpass
echo "Enter a password for the database root user"
read dbrootpass

# Get to work!

echo "#######"
echo "Starting MariaDB and Redis"
echo "#######"

systemctl start mariadb
systemctl enable mariadb
systemctl start redis
systemctl enable redis

echo "#########"
echo "Configuring MariaDB"
echo "#########"

mysql_secure_installation

mysql -e "CREATE DATABASE $dbname;"
mysql -e "CREATE USER $dbuser@'localhost' IDENTIFIED BY $dbpass;"
mysql -e "GRANT ALL ON $dbname.* TO $dbuser@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

echo "########"
echo "Configuring Memory Caching to use Redis"
echo "########"

echo "'memcache.local' => '\OC\Memcache\APCu'," >> /var/www/html/nextcloud/config/config.php
echo " 'redis' => array(" >> /var/www/html/nextcloud/config/config.php
echo "     'host' => 'localhost'," >> /var/www/html/nextcloud/config/config.php
echo "     'port' => 6379," >> /var/www/html/nextcloud/config/config.php
echo "      )," >> /var/www/html/nextcloud/config/config.php

echo "#########"
echo "All Done!  Don't forget your credentials"
echo "The database name is $dbname."
echo "The database user is $dbuser with password $dbpass."
echo "The database root user password is $dbrootpass."
echo "#########"
echo ""