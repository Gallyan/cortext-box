#!/bin/sh
tput setab 7; tput setaf 1;echo "5.1 Préconfig apt$(tput sgr 0)"
sudo debconf-set-selections /vagrant/preconfig.txt 2> /dev/null


tput setab 7; tput setaf 1;echo "5.2 Téléchargement des packages$(tput sgr 0)"
sudo apt-get update
sudo apt-get install -y --force-yes apache2 php5 php5-mysql mysql-server phpmyadmin libapache2-mod-wsgi libapache2-mod-php5 mysql-client php-pear curl php5-cli php5-dev php5-gd php5-curl php5-intl postfix mailutils git python-setuptools htop atop nethogs nmap multitail


tput setab 7; tput setaf 1;echo "5.3 Installation de Composer$(tput sgr 0)"
cd
curl -s https://getcomposer.org/installer | php
sudo ln -s /home/vagrant/composer.phar /usr/local/bin/composer


tput setab 7; tput setaf 1;echo "5.4 Installation de PHPUnit$(tput sgr 0)"
cd
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/bin/phpunit


tput setab 7; tput setaf 1;echo "7.1 Fichiers de configuration de PHP$(tput sgr 0)"
cd /vagrant/config_files/
sudo cp etc/php5/cli/php.ini /etc/php5/cli/php.ini
sudo cp etc/php5/apache2/php.ini /etc/php5/apache2/php.ini


#Pour travailler en local, afin de permettre de recevoir des mails locaux, postfix est configuré pour recevoir les mails à destination de local.dev. Ce réglage ne doit donc pas être reproduit en production. Adapter le chemin pour être à la racine des fichiers de config.
tput setab 7; tput setaf 1;echo "7.2 Fichiers de configuration de PostFix$(tput sgr 0)"
cd /vagrant/config_files/
sudo cp etc/postfix/main.cf /etc/postfix/main.cf


tput setab 7; tput setaf 1;echo "7.3 Fichiers de configuration de PHPMyAdmin$(tput sgr 0)"
cd /vagrant/config_files/
sudo cp etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-enabled/phpmyadmin.conf


#Modification pour activer la coloration syntaxique, les alias, et le prompt. A ne pas reproduire en production !!
tput setab 7; tput setaf 1;echo "7.4 Fichiers de configuration du shell$(tput sgr 0)"
cd /vagrant/config_files/
cp home/vagrant/.bashrc /home/vagrant/.bashrc
cp home/vagrant/.bash_aliases /home/vagrant/.bash_aliases
chmod 644 /home/vagrant/.bash_aliases
sudo cp root/.bashrc /root/.bashrc
sh /home/vagrant/.bashrc


tput setab 7; tput setaf 1;echo "7.5 Configuration Apache$(tput sgr 0)"
sudo a2enmod rewrite headers 
sudo a2dismod -f autoindex status access_compat

#Copie des fichiers de configuration Apache. Adapter éventuellement les fichiers en fonction de l'emplacement des fichiers sources et des fichiers de logs. Les fichiers sont prévus pour une installation en machine virtuelle dans le répertoire /vagrant sur des noms de domaines locaux. Les noms de domaines sont également à adapter.

cd /vagrant/config_files/
sudo cp etc/apache2/envvars /etc/apache2/envvars
sudo cp etc/apache2/sites-available/*.conf /etc/apache2/sites-available/
sudo chmod 644 /etc/apache2/sites-available/*.conf

#Activation des nouveaux sites installés et désactivation du site par défaut

sudo a2dissite 000-default
sudo a2ensite localhost.dev


tput setab 7; tput setaf 1;echo "7.7 Fichier /etc/hosts$(tput sgr 0)"
echo "127.0.0.1 localhost.dev" | sudo tee --append /etc/hosts > /dev/null


tput setab 7; tput setaf 1;echo "7.8 Locales$(tput sgr 0)"
echo "Europe/Paris" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

sudo sed -i 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen

echo "# Default locale for the system environment:
# Choices: None, en_US.UTF-8, fr_FR.UTF-8
locales locales/default_environment_locale      select  fr_FR.UTF-8
# Locales to be generated:
locales locales/locales_to_be_generated multiselect     en_US.UTF-8 UTF-8, fr_FR.UTF-8 UTF-8" > /home/vagrant/tmp_locales.txt
sudo debconf-set-selections /home/vagrant/tmp_locales.txt
rm /home/vagrant/tmp_locales.txt

sudo dpkg-reconfigure --frontend=noninteractive locales


if [ -e /vagrant/win_install.flag ]
then
  tput setab 7; tput setaf 1;echo "7.9 Fichiers de configuration pour Windows$(tput sgr 0)"
  cd /vagrant
fi


tput setab 7; tput setaf 1;echo "14 Fin$(tput sgr 0)"
cd
sudo service apache2 restart
echo "Rebooter la machine virtuelle via les commandes suivantes:"
echo "exit"
echo "vagrant reload"
if [ -e /vagrant/win_install.flag ]
then
  echo "Puis acceder à la page web http://127.0.0.1:3000"
else
  echo "Puis acceder à la page web http://10.10.10.10:3000"
fi
