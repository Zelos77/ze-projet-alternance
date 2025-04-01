# Projet d'alternance - Zelos77

Bienvenue sur le dépôt **Zelos77/ze-projet-alternance**, qui regroupe le site web, l'API et les scripts de déploiement de mon projet d'alternance. Ce projet est hébergé sur une infrastructure aws
**Attention, les ressources utilisées sont payantes**

## 📁 Structure du projet

```
ze-projet-alternance/
├── backend/       # API FastAPI pour la gestion des commentaires
├── frontend/      # Site HTML statique (page principale + commentaires)
├── setup/         # Script d'installation EC2 (user-data)
├── infra/         # TODO - IaC avec Terraform
```

---

## 🔧 Fonctionnalités principales

### 🌐 Frontend (`/frontend/index.html`)
- Page web moderne (dark theme, tech/cloud design)
- Présentation des projets d’alternance sur 2 ans
- Sections :
  - Architecture sécurisée AWS
  - Infrastructure as Code (IaC)
  - CI/CD avec GitHub
- Chaque section intègre un espace de **commentaires** avec :
  - Saisie pseudo + commentaire
  - Affichage date au format `DD/MM/YY HH:MM`
  - Affichage du plus récent en haut

### 🚀 Backend (`/backend/main.py`)
- API FastAPI en cours de mise en place (WIP)
- 2 routes prévues :
  - `POST /commentaires` → enregistrement dans DynamoDB
  - `GET /commentaires?sectionId=...` → récupération triée

### 📜 Setup EC2 (`/setup/ec2-userdata.sh`)
- Script `user-data` pour instance EC2 Ubuntu
- Actions :
  - Installation des paquets nécessaires (Python, pip, git...)
  - Clonage du dépôt GitHub
  - Installation des dépendances Python
  - Démarrage automatique de l'API FastAPI avec `uvicorn`
  - Déploiement du site HTML dans `/var/www/html`

---

## ⚙️ Déploiement sur AWS EC2 (résumé)

1. Lancer une instance EC2 Ubuntu 22.04
2. Ouvrir les ports 22, 80, 443 et 8000 dans le groupe de sécurité
3. Ajouter le contenu de `setup/ec2-userdata.sh` dans le champ **User data**
4. Accéder au site via `http://<IP-EC2>`
5. L’API est disponible sur `http://<IP-EC2>:8000/commentaires`

---

## 📦 Dépendances (backend)
Fichier `backend/requirements.txt` :
```txt
fastapi
uvicorn
boto3
```

---

## 🛠️ Prochaines étapes
- [ ] Connecter le frontend à l’API
- [ ] Stocker les commentaires dans DynamoDB
- [ ] Ajouter HTTPS avec Let's Encrypt
- [ ] Ajout d'un nom de domaine via Route 53
- [ ] CI/CD GitHub Actions (optionnel)

---

## 🧑‍💻 Auteur
**Antony Ceccaroli** — Projet personnel dans le cadre de l’alternance (cloud/devops)

GitHub : [Zelos77](https://github.com/Zelos77)

