#!/bin/bash

# Mise à jour des paquets
sudo dnf update -y

# Installer Git, Python3, pip, unzip, Nginx
sudo dnf install -y git python3 python3-pip unzip nginx

# Démarrer et activer nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Aller dans le dossier utilisateur
cd /home/ec2-user

# Cloner la branche de test du dépôt GitHub
git clone --branch main https://github.com/Zelos77/ze-projet-alternance.git

# Installer les dépendances du backend
cd ze-projet-alternance/backend
pip3 install -r requirements.txt

# Lancer le backend FastAPI en arrière-plan
nohup uvicorn main:app --host 0.0.0.0 --port 8000 &

# Copier le site web dans le dossier public nginx
sudo cp ../frontend/index.html /usr/share/nginx/html/index.html

# (Optionnel) Donner les bons droits
sudo chown nginx:nginx /usr/share/nginx/html/index.html
