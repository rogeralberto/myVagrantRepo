#!/usr/bin/env bash

#Author: Roger Olivares 2016  myVagrantFile - Provision
#                             Provisioning the vagrant virtual machine enviroment for hashicorp/precise64

echo "Updating"
apt-get  update
echo "Installing apache2"
apt-get install -y apache2
echo "Installing PHP5"
apt-get install -y php5-common libapache2-mod-php5 php5-cli
echo "Installing mysql-server-5 with password: 123456"
echo "mysql-server-5.5 mysql-server/root_password password 123456" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password 123456" | debconf-set-selections
apt-get install -y mysql-server-5.5
echo "Install mysql php5-mysqlnd"
apt-get install -y php5-mysqlnd
echo "Install npm"
apt-get install -y npm
echo "Install Composer"
cd /var/www/web
echo "Changing directory OK..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
echo "Composer install OK"
echo "Create softlink for vagrant share folder and renaming to /var/www"
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi
#Verify if fqdn file exist to prevent apache's warning
#Could not reliably determine the server's fully qualified domain name
echo "Prevent - Could not reliably determine the server's fully qualified domain name"
A="/etc/apache2/conf.d/fqdn"
if [ -f "${A}" ]; then
  echo "The file 'fqdn' exists, nothing to do"
else
  echo "Creating 'fqdn' file in '/etc/apache2/conf.d'"
  touch ${A}
  echo "ServerName localhost" > ${A}
fi
echo "Restarting Apache"
service apache2 restart

