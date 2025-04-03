#!/bin/bash
# Mise à jour du système
sudo dnf update -y

# Installation de nginx
sudo dnf install -y nginx

# Création d'une page d'accueil simple
sudo echo "<h1>Bienvenue sur mon instance EC2 - RED - $(hostname)</h1>" > /usr/share/nginx/html/index.html

# Activation et démarrage du service nginx
systemctl enable nginx
systemctl start nginx