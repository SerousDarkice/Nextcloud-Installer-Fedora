#!/bin/bash

echo "#######"
echo "Welcome to the Nextcloud MariaDB configuration script!"
echo "#######"

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

#Create a database for nextcloud and a user to access it.
mysql -e "CREATE DATABASE nextcloud;"
mysql -e "CREATE USER 'ncuser'@'localhost' IDENTIFIED BY 'ncuserpassword';"
mysql -e "GRANT ALL ON nextcloud.* TO 'ncuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

#Secure mariadb. These commands do what mysql_secure_installation does interactively
mysql -e "UPDATE mysql.user SET Password=PASSWORD('somesecurepassword') WHERE User='root';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE test;"
mysql -e "FLUSH PRIVILEGES;"

echo "########"
echo "Configuring PHP Stuff"
echo "########"

sed -i -e 's/;opcache.enable_cli=0/opcache.enable_cli=1/' /etc/php.d/10-opcache.ini;
sed -i -e 's/opcache.max_accelerated_files=4000/opcache.max_accelerated_files=10000/' /etc/php.d/10-opcache.ini;
sed -i -e 's/;opcache.save_comments=1/opcache.save_comments=1/' /etc/php.d/10-opcache.ini;
sed -i -e 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=1/' /etc/php.d/10-opcache.ini;

systemctl restart php-fpm

echo "#########"
echo "All Done!  Enjoy Nextcloud"
echo "#########"
echo ""