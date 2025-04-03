#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

# Mise à jour du système
dnf update -y

# Installation de nginx
dnf install -y git nginx python3-pip

# Aller dans le dossier utilisateur
cd /home/ec2-user

# Cloner la branche main du dépôt GitHub
git clone --branch main https://github.com/Zelos77/ze-projet-alternance.git

cd ze-projet-alternance/backend
pip3 install -r requirements.txt

# Copier le site web dans le dossier public nginx
cp -f /home/ec2-user/ze-projet-alternance/frontend/index_red.html /usr/share/nginx/html/index.html

# Activation et démarrage du service nginx
systemctl enable nginx
systemctl start nginx