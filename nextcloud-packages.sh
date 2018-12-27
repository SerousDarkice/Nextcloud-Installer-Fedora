#!/bin/bash

# Set variables

echo "##########"
echo "Setting up variables"
echo "##########"

server_packages="httpd mariadb mariadb-server redis"
php_packages="php php-pecl-apcu php-gd php-gmp php-json php-pecl-imagick php-imap php-intl php-json php-ldap php-mbstring php-pear-Net-Curl php-pecl-mcrypt php-mysqlnd php-opcache php-process php-redis php-smbclient php-xml php-pecl-zip"
selinux_packages="policycoreutils policycoreutils-python policycoreutils-python-utils"
app_packages="bzip2 libreoffice tar fail2ban"
nextcloud_download="https://download.nextcloud.com/server/releases/nextcloud-15.0.0.tar.bz2"
nextcloud_file="nextcloud-15.0.0.tar.bz2"
web_directory="/var/www/html/nextcloud"
data_directory="/var/www/html/nextcloud/data"

# Start the work

echo "##########"
echo "Updating Linux"
echo "##########"

dnf upgrade -y

echo "##########"
echo "Installing packages"
echo "##########"

dnf install -y $server_packages $php_packages $selinux_packages $app_packages

echo "##########"
echo "Creating directories, downloading NextCloud and copying files"
echo "##########"

mkdir -p $web_directory $data_directory
cd /tmp
curl -o $nextcloud_file $nextcloud_download
tar -xjvf $nextcloud -C $web_directory

echo "##########"
echo "All Done!  Proceed to webserver configuration!"
echo "##########"
echo ""