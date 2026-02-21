#!/usr/bin/env bash

echo -e "\n:: Generating ssh key"
mkdir -p ~/.ssh
ssh-keyscan -t ed25519 github.com >>~/.ssh/known_hosts 2>/dev/null

if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "138178283+jhonnikek@users.noreply.github.com" -f ~/.ssh/id_ed25519 -q -N ""
fi
eval "$(ssh-agent -s)" >/dev/null
ssh-add ~/.ssh/id_ed25519 2>/dev/null

cat <<EOF

:: ssh key:
$(cat ~/.ssh/id_ed25519.pub)
===========================

EOF
