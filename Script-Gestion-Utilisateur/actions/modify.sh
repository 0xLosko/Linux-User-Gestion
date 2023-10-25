#!/bin/bash
clear
echo -e "Action choisie : modification d'un utilisateur\n"
awk -F: '$3 >= 1000 && $3 < 65000' /etc/passwd | cat -n

echo -e "\nSaisir le nom de l'utilisateur à modifier : "
read user_to_modify

# User exist ?
if id "$user_to_modify" &>/dev/null; then
    echo -e "\nOptions de modification :"
    read -p "Modifier le nom d'utilisateur (y/n) : " modify_user_name
    read -p "Modifier le chemin du dossier utilisateur (y/n) : " modify_user_path
    read -p "Modifier la date d'expiration (y/n) : " modify_date_expiration
    read -p "Modifier le mot de passe (y/n) : " modify_password
    read -p "Modifier le Shell (y/n) : " modify_shell
    read -p "Modifier l'identifiant (y/n) : " modify_uid
    if [ "$modify_user_name" = "y" ]; then
        new_user_name=""
        while [ -z "$new_user_name" ]; do
            read -p "Entrez le nouveau nom d'utilisateur : " new_user_name
            if [ -z "$new_user_name" ]; then
                echo "Erreur : Le nom d'utilisateur ne peut pas être vide."
            fi
        done
        usermod -l "$new_user_name" "$user_to_modify"
        user_to_modify="$new_user_name"
    fi
if [ "$modify_user_path" = "y" ]; then
    new_user_path=""
    old_home_dir=$(eval echo ~"$user_to_modify")
    while true; do
        read -p "Entrez le nouveau chemin du dossier utilisateur (ou appuyez sur Entrée pour conserver le même) : " new_user_path
        if [ -z "$new_user_path" ]; then
            echo "Vous avez choisi de conserver le même chemin du dossier utilisateur."
            break 
        elif [ -e "$new_user_path" ]; then
            echo "Erreur : Le chemin $new_user_path existe déjà."
        else
            break
        fi
    done

    if [ -n "$new_user_path" ]; then
        if [ ! -d "$new_user_path" ]; then
            mkdir -p "$new_user_path"
        fi
        cp -r "$old_home_dir/" "$new_user_path"
        rm -r "$old_home_dir"
        usermod -d "$new_user_path" "$user_to_modify"
    fi
fi


# modify exp date
if [ "$modify_date_expiration" = "y" ]; then
    while [ -z "$date_expiration" ] || [ "$(date -d "$date_expiration" +%s 2>/dev/null)" -lt "$(date +%s)" ]
do
    echo "Entrez la date d'expiration (au format YYYY-MM-DD) :"
            read -p "Entrez la nouvelle date d'expiration (au format YYYY-MM-DD) : " date_expiration

    if [ -z "$date_expiration" ]
    then
        echo "Erreur : La date d'expiration ne peut pas être vide."
    elif [ "$(date -d "$date_expiration" +%s 2>/dev/null)" -lt "$(date +%s)" ]
    then
        echo "Erreur : La date d'expiration est antérieure à aujourd'hui."
    fi
done
 chage -E "$new_date_expiration" "$user_to_modify"
fi




    # Modify password
    if [ "$modify_password" = "y" ]; then
        read -p "Nouveau mot de passe de l'utilisateur : " new_password
        (echo -e "$new_password\n$new_password" | passwd "$user_to_modify") > /dev/null 2>&1
    fi

    # Modify shell path
    if [ "$modify_shell" = "y" ]; then
        new_shell_path=""
        while [ -z "$new_shell_path" ] || [ ! -e "$new_shell_path" ]; do
            read -p "Entrez le nouveau chemin du Shell : " new_shell_path
            if [ -z "$new_shell_path" ]; then
                echo "Erreur : Le chemin du Shell ne peut pas être vide."
            elif [ ! -e "$new_shell_path" ]; then
                echo "Erreur : Le Shell n'est pas installé."
            else
                chsh -s "$new_shell_path" "$user_to_modify"
            fi
        done
    fi

    # Modify id
    if [ "$modify_uid" = "y" ]; then
        new_uid=""
        while [ -z "$new_uid" ]; do
            read -p "Entrez le nouvel identifiant (UID) : " new_uid
            if [ -z "$new_uid" ]; then
                echo "Erreur : L'identifiant ne peut pas être vide."
            fi
        done
        usermod -u "$new_uid" "$user_to_modify"
    fi

    echo "L'utilisateur $user_to_modify a été modifié avec succès."
    ./main.sh
else
    echo "Erreur : L'utilisateur $user_to_modify n'existe pas."
    exit 1
fi
