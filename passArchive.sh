#!/bin/bash

menu() 
{
    PS3='Choose what to do: '
    options=("Add an account" "Find an account" "Modify an account" "Delete an account" "Quit")
    select opt in "${options[@]}"
    do
		case $opt in
	    	"Add an account")
				add_an_account
				echo
				menu
				;;
	    	"Find an account")
				find_an_account
				echo
				menu
				;;
	    	"Modify an account")
				modify_an_account
				echo
				menu
				;;
			"Delete an account")
				delete_an_account
				echo
				menu
				;;
	    	"Quit")
				break
				;;
	    	*) echo "Invalid option";;
		esac
    done
}

add_an_account()
{
	read -p "Enter the name of the site: " site
	read -p "Enter your email (or username): " name
	read -p "Do you already have a password for this account? [Y/N] " already_has_pass
	if [[ "$already_has_pass" == n ]] || [[ "$already_has_pass" == N ]] ;
	then
		generate_new_password
	else
		read -sp "Enter your password (Hidden): " password
	fi
	
	echo "$site,$name,$password" >> passwords.csv
	echo "Account saved."
}

generate_new_password() 
{
    password=$(date +%s | sha256sum | base64 | head -c 32)
    echo "Password Generated."
}

find_an_account()
{
	read -p "What account do you want to find?" to_find
	grep $to_find passwords.csv >> found.csv 
	awk -F "\"*,\"*" '{print "Username: "$2 " Password:" $3}' found.csv
	rm found.csv
	
}



# MAIN

# Make sure user runs script as sudo
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Check if Passwords file's Env variable exists. If not, creates it.
if ! [[ -z $ENV_PAPATH ]]
then
	read -p "Where do you want to store your passwords?: " ENV_PAPATH
	echo export "ENV_PAPATH=$ENV_PAPATH" >> $HOME/.bashrc
fi
cd $ENV_PAPATHS
menu






