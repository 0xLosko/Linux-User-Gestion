#!/bin/bash

clear
echo -e "Action choisie : Ajout d'un utilisateur \n"

#Name
user_name=""

while [ -z "$user_name" ]
do
    echo "Entrez le nom d'utilisateur :"
    read user_name
    if [ -z "$user_name" ]
    then
        echo "Erreur : Le nom d'utilisateur ne peut pas être vide."
    fi
done

#path
user_path=""

while [ -z "$user_path" ] || [ -e "$user_path" ]
do
    echo "Entrez le chemin du dossier utilisateur:"
    read user_path

    if [ -z "$user_path" ]
    then
        echo "Erreur : Le chemin du dossier utilisateur ne peut pas être vide."
    elif [ -e "$user_path" ]
    then
        echo "Erreur : Le chemin $user_path existe deja."
    fi
done

#date
date_expiration=""

while [ -z "$date_expiration" ] || [ "$(date -d "$date_expiration" +%s 2>/dev/null)" -lt "$(date +%s)" ]
do
    echo "Entrez la date d'expiration (au format YYYY-MM-DD) :"
    read date_expiration

    if [ -z "$date_expiration" ]
    then
        echo "Erreur : La date d'expiration ne peut pas être vide."
    elif [ "$(date -d "$date_expiration" +%s 2>/dev/null)" -lt "$(date +%s)" ]
    then
        echo "Erreur : La date d'expiration est antérieure à aujourd'hui."
    fi
done

#shell
shell_path=""

while [ -z "$shell_path" ] || [ ! -e "$shell_path" ]
do
    echo "Entrez le chemin du shell :"
    read shell_path

    if [ -z "$shell_path" ]
    then
        echo "Erreur : Le chemin du shell ne peut pas être vide."
    elif [ ! -e "$shell_path" ]
    then
        echo "Erreur : Le shell n'est pas installé."
    fi
done

#create user
useradd --create-home -d "$user_path" -e "$date_expiration" -s "$shell_path" "$user_name"

#password
read -p "Mot de passe de l'utilisateur : " password
(echo -e "$password\n$password" | passwd "$user_name") > /dev/null 2>&1


echo "L'utilisateur $user_name a été créé avec succès"
./main.sh