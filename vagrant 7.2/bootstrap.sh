# Update Packages
echo "----- UPDATE PACKAGES -----"
apt-get update
# Upgrade Packages
apt-get upgrade

# Basic Linux Stuff
# echo "----- INSTALLING GIT -----"
# apt-get install -y git

# Apache
echo "----- INSTALLING APACHE -----"
apt-get install -y apache2

# Enable Apache Mods
a2enmod rewrite

#Add Onrej PPA Repo
echo "----- INSTALLING PHP -----"
apt-add-repository ppa:ondrej/php
apt-get update

# Install PHP
apt-get install -y php7.2

# PHP Apache Mod
apt-get install -y libapache2-mod-php7.2

# Restart Apache
service apache2 restart

# PHP Mods
apt-get install -y php7.2-common
apt-get install -y php7.2-mcrypt
apt-get install -y php7.2-zip
apt-get install -y php7.2-dev

# Xdebug
echo "----- INSTALLING XDEBUG -----"
tar xvzf /var/www/xdebug-2.6.1.tgz -C /tmp
cd /tmp/xdebug-2.6.1
phpize
./configure
make
sudo cp modules/xdebug.so /usr/lib/php/20170718
echo "" >> /etc/php/7.2/apache2/php.ini
echo "[xdebug]" >> /etc/php/7.2/apache2/php.ini
echo "zend_extension = /usr/lib/php/20170718/xdebug.so" >> /etc/php/7.2/apache2/php.ini
echo "xdebug.remote_enable=1" >> /etc/php/7.2/apache2/php.ini
echo "xdebug.remote_host=192.168.33.10" >> /etc/php/7.2/apache2/php.ini
echo "xdebug.remote_port=9000" >> /etc/php/7.2/apache2/php.ini

# Set MySQL Pass
echo "----- INSTALLING MYSQL -----"
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

# Install MySQL
apt-get install -y mysql-server

# PHP-MYSQL lib
apt-get install -y php7.2-mysql

# Restart Apache
sudo service apache2 restart

# Create db / user
echo "----- CRATING MYSQL USER AND DB -----"
DB_NAME="db_name"
DB_USER="db_user"
DB_PASSWORD="db_password"
mysql -uroot -proot -e "create database $DB_NAME;"
mysql -uroot -proot -e "create user $DB_USER;"
mysql -uroot -proot -e "grant all on *.* to '$DB_USER'@'localhost' identified by '$DB_PASSWORD';"
if [ -f /var/www/db.sql ]; then
    mysql -uroot -proot $DB_NAME -e "source /var/www/db.sql;"
fi

## WP-SR
# cd /var/www/html
# curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# php /tmp/wp-cli.phar --version
# php /tmp/wp-cli.phar search-replace 'search-string' 'replaced-string'
# rm /tmp/wp-cli.phar
