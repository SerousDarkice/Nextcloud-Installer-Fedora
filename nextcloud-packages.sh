#!/bin/bash


# Install packages

echo "##########"
echo "Installing Packages"
echo "##########"

dnf install -y unzip httpd mariadb mariadb-server php php-json php-xml php-gd php-mbstring php-process php-pecl-zip php-intl php-pecl-mcrypt php-mysqlnd php-gmp php-pecl-imagick php-pecl-redis php-ldap php-pecl-apcu redis libreoffice policycoreutils policycoreutils-python policycoreutils-python-utils fail2ban

echo "##########"
echo "Download NextCloud and Copying to appropriate directory"
echo "##########"

# Download, unzip, and copy NextCloudFiles
cd /tmp
curl -o nextcloud-14.0.4.zip https://download.nextcloud.com/server/releases/nextcloud-14.0.4.zip
unzip nextcloud-14.0.4.zip
cp -ar nextcloud /var/www/html

echo "##########"
echo "all done"
echo "##########"
echo ""