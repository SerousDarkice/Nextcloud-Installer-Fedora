#!/bin/bash

# Configure MariaDB

echo "Enter a database user name"
read dbuser
echo "Enter a password for the database user"
read dbpass
echo "Enter a password for the database root user"
read dbrootpass

systemctl start mariadb
systemctl enable mariadb
systemctl start redis
systemctl enable redis

echo "#########"
echo "Configuring MariaDB"
echo "#########"

mysql -e "CREATE DATABASE nextcloud;"
mysql -e "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"
mysql -e "GRANT ALL ON nextcloud.* TO '$dbuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "UPDATE mysql.user SET Password=PASSWORD('$dbrootpass') WHERE User='root';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE test;"
mysql -e "FLUSH PRIVILEGES;"

# Configure data caching with Redis

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
echo "The database user is $dbuser with password $dbpass"
echo "The database root user password is $dbrootpass"
echo "#########"
echo ""