#!/bin/bash

# This script is an update to Scott Alan Miller's script from MangoLassi.
# https://gitlab.com/scottalanmiller/nextcloud_fedora_installer/raw/master/nextcloud_fedora.sh
# I couldn't get it to work with NC 14 and Fedora 27 or 28, so I'm
# using it as a framework and working on my own.  This is also an opporunity
# to work on some of my own skills.

# I'l be turning these dnf commands into a single line for the final script.

# Update system

dnf update -y

# Set variables

server_packages="httpd mariadb mariadb-server redis"
php_packages="php php-pecl-apcu php-gd php-gmp php-json php-pecl-imagick php-imap php-intl php-json php-ldap php-pear-MDB2 php-pear-MDB2-driver-mysql php-mbstring php-pear-Net-Curl php-pecl-mcrypt php-mysqlnd php-opcache php-process php-redis php-smbclient php-xml php-pecl-zip"
selinux_packages="policycoreutils policycoreutils-python policycoreutils-python-utils"
app_packages="bzip2 libreoffice tar"
nextcloud_download="https://download.nextcloud.com/server/releases/nextcloud-15.0.0.tar.bz2"
nextcloud_file="nextcloud-15.0.0.tar.bz2"
web_directory="/var/www/html/nextcloud"
data_directory="/var/www/html/nextcloud/data"

# Create directories

mkdir -p $web_directory $data_directory

# Install packages

dnf install -y  $server_packages $php_packages $selinux_packages $app_packages


# Download, unzip, and copy NextCloudFiles
cd /tmp
curl -o $nextcloud_file $nextcloud_download
tar -xjvf $nextcloud_file -C $web_directory

# Everything under here needs to be checked / redone

# Configure data caching with Redis
echo "'memcache.local' => '\OC\Memcache\Redis'," >> /var/www/html/nextcloud/config/config.php
echo " 'redis' => array(" >> /var/www/html/nextcloud/config/config.php
echo "     'host' => 'localhost'," >> /var/www/html/nextcloud/config/config.php
echo "     'port' => 6379," >> /var/www/html/nextcloud/config/config.php
echo "      )," >> /var/www/html/nextcloud/config/config.php


systemctl start redis
systemctl enable redis

# Configure SELinux

setsebool -P httpd_can_sendmail 1
setsebool -P httpd_can_network_connect 1

semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/data(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/config(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/apps(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/.htaccess'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/.user.ini'

restorecon -Rv '/var/www/html/nextcloud/'

# Start Apache

systemctl start httpd
systemctl enable httpd

# Configure Firewall

firewall-cmd --add-port=http/tcp --permanent
firewall-cmd --reload