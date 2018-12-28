#!/bin/bash

# Set Variables

web_directory="/var/www/html/nextcloud"

# Get t'work!

echo "########"
echo "Installing Jared Busch's Nextcloud apache file"
echo "########"

curl -o /etc/httpd/conf.d/nextcloud.conf https://raw.githubusercontent.com/sorvani/scripts/master/Nextcloud/nextcloud.conf

echo "########"
echo "Setting File Permissions"
echo "########"

chown apache:apache -R /var/www/html/nextcloud

echo "########"
echo "Allowing HTTP traffic through the firewall"
echo "########"

firewall-cmd --add-port=http/tcp --permanent
firewall-cmd --reload

echo "########"
echo "Configure SELinux"
echo "########"

setsebool -P httpd_can_sendmail 1
setsebool -P httpd_can_network_connect 1

semanage fcontext -a -t httpd_sys_rw_content_t "$web_directory/data(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t "$web_directory/config(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t "$web_directory/apps(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t "$web_directory/.htaccess"
semanage fcontext -a -t httpd_sys_rw_content_t "$web_directory/.user.ini"

restorecon -FRv $web_directory

echo "########"
echo "Starting Apache"
echo "########"

systemctl start httpd
systemctl enable httpd

echo "########"
echo "Starting Fail2Ban"
echo "########"

systemctl start fail2ban
systemctl enable fail2ban

echo "########"
echo "All done!  Contine to the database configuration script!"
echo "########"
echo ""