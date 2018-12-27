#!/bin/bash

# Start Apache

echo "########"
echo "Starting Apache"
echo "########"

systemctl start httpd
systemctl enable httpd

echo "########"
echo "Setting File Permissions"
echo "########"

chown apache:apache -R /var/www/html/nextcloud

# Configure Firewall

echo "########"
echo "Opening the firewall a little"
echo "########"

firewall-cmd --add-port=http/tcp --permanent
firewall-cmd --reload

# Configure SELinux

echo "########"
echo "Configure SELinux"
echo "########"

setsebool -P httpd_can_sendmail 1
setsebool -P httpd_can_network_connect 1

semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/data(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/config(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/apps(/.*)?'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/.htaccess'
semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/.user.ini'

restorecon -R '/var/www/html/nextcloud/'

# Fail2Ban Time

echo "#######"
echo "Starting Fail2Ban"
echo "#######"

systemctl start fail2ban
systemctl enable fail2ban