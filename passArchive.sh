#!/bin/bash

generate_new_password() 
{
    new_password=$(date +%s | sha256sum | base64 | head -c 32)
    echo "Password Generated."
}

add_password() {
    echo "$site, $username, $new_password" >> passwords.csv
}


echo "Website: "
read site
echo "Username: "
read username
generate_new_password
add_password




