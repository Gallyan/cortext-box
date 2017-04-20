#/bin/sh

echo -e "\e[1;32m=== Script de reset de la Dev-Box, suppression de la machine virtuelle et des sources si elles existent\e[0m"
echo -e "\e[1;31m### Etes-vous sûr de vouloir tout supprimer [o/N] ?"
read choix

if [ "$choix" == "o" ] || [ "$choix" == "O" ]
then
   echo -e "\e[1;32m=== Arrêt de la machine virtuelle au cas ou...\e[0m"
   vagrant halt

   echo -e "\e[1;32m=== Suppression de la MV\e[0m"
   vagrant destroy -f

   echo -e "\e[1;32m=== Suppression des fichiers\e[0m"
   if [ -d .vagrant ]
   then
      echo -e "\e[1;32m=== Del .vagrant\e[0m"
      rm -rf .vagrant
   fi

   echo -e "\e[1;32m=== Suppression des sources\e[0m"

   if [ -f repositories.conf ]
   then
     liste=repositories.conf
   else
     liste=repositories.conf.dist
   fi

   nb=0
   while IFS='' read -r line || [[ -n "$line" ]];
   do
     if [ "`echo $line|cut -b 1`" != "#" ]
     then

       # Lecture des paramètres
       repo=`echo "$line"|cut -d";" -f1`
       name=`echo $repo|cut -d "/" -f2|cut -d "." -f1`

       echo -e "\e[1;32m=== Suppression de $repo\e[0m"
       rm -rf repo-$name

       nb=`expr $nb + 1`

     fi
   done < $liste

else
   echo -e "\e[1;32m=== Annulation de la suppression\e[0m"
fi

echo -e "\e[1;32m=== Fin\e[0m"
