#!/bin/bash
clear
echo -e "Action choisie : Suppression d'un utilisateur\n"
awk -F: '$3 >= 1000 && $3 < 65000' /etc/passwd | cat -n

echo -e "\nSaisir le nom de l'utilisateur à supprimer : "
read user_to_delete

# Vérifiez si l'utilisateur existe
if id "$user_to_delete" &>/dev/null; then
    echo -e "\nOptions de suppression :"
    read -p "Supprimer le dossier utilisateur (y/n) : " delete_user_directory
    read -p "Supprimer l'utilisateur même s'il est connecté (y/n) : " delete_user_connected

    if [ "$delete_user_directory" = "y" ]; then
        userdel -r "$user_to_delete" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "L'utilisateur $user_to_delete a été supprimé avec succès."
            exit 0  # Succès
        else
            echo "Erreur lors de la suppression du dossier utilisateur." >&2
            exit 2  # Code d'erreur pour échec de suppression du dossier utilisateur
        fi
    else
        userdel "$user_to_delete" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "L'utilisateur $user_to_delete a été supprimé avec succès."
            ./main.sh
        else
            echo "Erreur lors de la suppression de l'utilisateur." >&2
            exit 3  # Code d'erreur pour échec de suppression de l'utilisateur
        fi
    fi

    if [ "$delete_user_connected" = "y" ]; then
        pkill -KILL -u "$user_to_delete" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "L'utilisateur $user_to_delete a été supprimé avec succès, même s'il était connecté."
            ./main.sh
        else
            echo "Erreur lors de la suppression de l'utilisateur connecté." >&2
            exit 4  # Code d'erreur pour échec de suppression de l'utilisateur connecté
        fi
    fi
else
    echo "Erreur : L'utilisateur $user_to_delete n'existe pas." >&2
    exit 1  # Code d'erreur pour utilisateur inexistant
fi