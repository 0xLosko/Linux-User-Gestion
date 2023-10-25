#!/bin/bash
echo -e "Script d'administration d'utilisateur\n"

echo -e "Saisir l'action à réaliser : \n
○ Ajout d'un utilisateur (a)
○ Modification d'un utilisateur (m)
○ Suppression d'un utilisateur (s)
○ Sortie du script (e)"

read user_input

case "$user_input" in
  "a")
    ./actions/add.sh
    ;;
  "m")
    ./actions/modify.sh
    ;;
  "s")
    ./actions/del.sh
    ;;
  "e")
    echo "Sortie du script"
    ;;
  *)
    echo "Action non reconnue. Sortie du script."
    ;;
esac
