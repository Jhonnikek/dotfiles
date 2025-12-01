#!/usr/bin/env bash

#git setup
echo -e "\nGit setup\n"
read -r -p "Name: " name
read -r -p "Email: " email

git config --global user.name "$name"
git config --global user.email "$email"

echo -e "\nInstalling devtools\n"
devtools=(
    lazygit
    lazydocker
    less
    openssh
    nodejs
    npm
    postgresql
    docker
)

services=(
    docker.service
    postgresql.service
)

for package in "${devtools[@]}";do
    sudo pacman -S --noconfirm --needed ${package}
done

# enable services
for service in "${services[@]}"; do
    if ! systemctl is-enabled "$service" &>/dev/null; then
        echo "Enabling $service..."
        sudo systemctl enable "$service"
        echo "done."
    else
        echo -e "\n$service is already enabled"
    fi
done

#generate ssh key
read -p $'\n-Do you want to generate ssh key? [y/N]: ' confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
    echo -e "\nGenerating ssh key...\n"
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519

    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        eval "$(ssh-agent -s)"
    fi

    ssh-add ~/.ssh/id_ed25519

    cat << EOF

=== Your ssh key ===
$(cat ~/.ssh/id_ed25519.pub)
===========================

Copy the above key and paste it in:
GitHub → Settings → SSH and GPG keys → New SSH key

EOF
else
    echo "Skipping generate ssh key..."
fi