#!/bin/bash

if [ ! -d ~/.gitusers ]; then
    mkdir ~/.gitusers
fi

# If number of arguments is different than 1, print usage and exit
if [ $# -ne 1 ]; then
    echo "Usage: $0 add-user | remove-user | change-user | list-users | current-user"
    exit 1
fi

_listusers() {
    for user in ~/.gitusers/*; do
        echo "User: $(basename $user)"
        echo "Email: $(sed -n 2p $user)"
        echo
    done
}

case $1 in
add-user)
    echo -n "Username: "
    read username
    echo -n "Email: "
    read email
    # Create a file in ~/.gitusers/ with the username and email, separated by a newline
    echo -e "$username\n$email" >~/.gitusers/"$username"
    ;;
remove-user)
    _listusers
    echo -n "Enter the username to remove: "
    read username
    rm -f ~/.gitusers/"$username"
    ;;
change-user)
    _listusers
    echo -n "Enter the username to change to: "
    read username
    if [[ ! -f ~/.gitusers/"$username" ]]; then
        echo "User not found"
        exit 1
    fi
    # Get username and email from the file
    email=$(sed -n 2p ~/.gitusers/"$username")
    git config --global user.name "$username"
    git config --global user.email "$email"
    ;;
list-user)
    _listusers
    ;;
current-user)
    username=$(git config --global user.name)
    email=$(git config --global user.email)
    echo "Username: $username"
    echo "Email: $email"
    ;;
*)
    echo "Invalid option"
    ;;
esac
