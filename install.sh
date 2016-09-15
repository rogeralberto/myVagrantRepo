#!/usr/bin/env bash

echo "Actualizando debian"
apt-get  update
echo "Instalando apache2"
apt-get install -y apache2
echo "Instalando PHP"
apt-get install -y php5-common libapache2-mod-php5 php5-cli
echo "Instalando mysql"
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi
#Verify if fqdn file exist to prevent apache's warning
#Could not reliably determine the server's fully qualified domain name
echo "Prevent - Could not reliably determine the server's fully qualified domain name"
A="/etc/apache2/conf.d/fqdn"
if [ -f $A ]; then
  echo "The file 'fqdn' exists, nothing to do"
else
  echo "Creating 'fqdn' file in '/etc/apache2/conf.d'"
  # cd /etc/apache2/conf.d
  sudo -s touch $A
  sudo -s echo "ServerName localhost" > $A
  sudo -k
fi
echo "Restarting Apache"
sudo service apache2 restart
