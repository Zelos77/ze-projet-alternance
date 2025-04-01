#!/bin/bash
apt update && apt install -y python3-pip nginx git unzip
cd /home/ubuntu

# Cloner ton projet GitHub
git clone https://github.com/tonuser/projet-alternance.git
cd projet-alternance/backend
pip3 install -r requirements.txt

# Lancer FastAPI
nohup uvicorn main:app --host 0.0.0.0 --port 8000 &

# Déployer le site HTML
cp /home/ubuntu/projet-alternance/frontend/index.html /var/www/html/index.html

