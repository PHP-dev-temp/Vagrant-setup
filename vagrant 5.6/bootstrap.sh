# Update Packages
echo "----- UPDATE PACKAGES -----"
sudo apt-get update
# Upgrade Packages
#apt-get upgrade

# Apache
echo "----- INSTALLING APACHE -----"
sudo apt-get install -y apache2

# Enable Apache Mods
sudo a2enmod rewrite

# Set MySQL Pass
echo "----- INSTALLING MYSQL -----"

# Setting MySQL root user password root/root
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt-get install -y mysql-server mysql-client

#Add Onrej PPA Repo
echo "----- INSTALLING PHP -----"
sudo apt-add-repository ppa:ondrej/php
sudo apt-get update

# Install PHP
sudo apt-get install -y php5.6 php5.6-mcrypt php5.6-mbstring php5.6-curl php5.6-cli php5.6-mysql php5.6-gd php5.6-intl php5.6-xsl php5.6-zip libapache2-mod-php5.6
sudo a2dismod php5
sudo a2enmod php5.6
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
