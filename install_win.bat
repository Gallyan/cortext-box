@echo off
echo.
echo ######## 3. Recuperation des sources depuis GitHub ########

echo.
echo ######## 3.7 Identification de l'installation en environnement Windows ########
echo. > win_install.flag

echo.
echo ######## 4. Telechargement de la machine virtuelle ########
echo Une fois la machine virtuelle demarree, lancer la suite de l'execution par la commande suivante:
echo install_inside.sh
vagrant up
vagrant ssh
