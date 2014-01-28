#!/bin/bash
#
# Installs common programs and others that have more complex install procedures
# TODO See the remaining items in my dotfiles planning doc
#

echo "Installing common programs"
sudo apt-get install firefox
sudo apt-get install gimp
sudo apt-get install git-core
sudo apt-get install google-chrome-stable
sudo apt-get install jedit
sudo apt-get install opera

# Prompt code from http://stackoverflow.com/a/1885534/328817

read -p "Do you want to install LAMP stack? (y/n)" -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # https://www.digitalocean.com/community/articles/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu
    
    sudo apt-get update
    sudo apt-get install apache2
    
    sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql
    sudo mysql_install_db
    sudo /usr/bin/mysql_secure_installation
    
    sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt
fi


read -p "Do you want to install NodeJS? (y/n)" -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo apt-get install python-software-properties
    sudo add-apt-repository ppa:chris-lea/node.js
    sudo apt-get update
    sudo apt-get install nodejs
fi

