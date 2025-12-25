#!/usr/bin/env bash

#git setup
read -r -p "Name: " name
read -r -p "Email: " email

git config --global user.name "$name"
git config --global user.email "$email"

#generate ssh key
echo -e "\n:: Generating ssh key\n"
ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

ssh-add ~/.ssh/id_ed25519

cat << EOF

:: ssh key: 
$(cat ~/.ssh/id_ed25519.pub)
===========================

Copy the above key and paste it in:
GitHub → Settings → SSH and GPG keys → New SSH key

EOF