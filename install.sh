#/bin/bash

tabs 4

tput setab 7; tput setaf 0;echo ">>> 3. Récupération des sources depuis GitHub$(tput sgr 0)"

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
    # param2=`echo "$line"|cut -d";" -f2`
    # param3=`echo "$line"|cut -d";" -f3`
    nb=`expr $nb + 1`

    echo -ne "\n\t"; tput setab 7; tput setaf 1;echo -e "3.$nb Clonage de $repo$(tput sgr 0)\n"
    git clone --recursive -C repo-$name $repo

  fi
done < $liste

if [ $nb -eq 0 ]
then
  echo -ne "\n\t"; tput setab 1; tput setaf 7; echo -e "Attention aucun repository n'est configuré$(tput sgr 0)\n"
elif [ $nb -eq 1 ]
then
  echo -ne "\n\t"; tput setab 2; tput setaf 7; echo -e "Installation d'un seul repository$(tput sgr 0)\n"
else
  echo -ne "\n\t"; tput setab 2; tput setaf 7; echo -e "Installation de $nb repositories$(tput sgr 0)\n"
fi

tput setab 7; tput setaf 0;echo ">>> 4. Téléchargement de la machine virtuelle$(tput sgr 0)"
echo -e "\n\tUne fois la machine virtuelle démarrée, lancer la suite de l'exécution par la commande suivante:"
echo -e "\tinstall_inside.sh"
vagrant up && vagrant ssh
