# 🌐 Projet Alternance – Vision d’une Architecture Cloud AWS Complète

Ce projet a pour objectif de mettre en place une **infrastructure cloud robuste, scalable et sécurisée** sur AWS. Il s'appuie sur les bonnes pratiques DevOps et Cloud Architect, tout en restant pédagogique et exploitable en environnement professionnel.

---

## 🧱 1. Hébergement du site web statique

- Le site HTML/CSS/JS sera hébergé dans un **bucket S3** configuré pour le mode "site statique"
- La distribution se fera via **CloudFront**, pour :
  - Améliorer les performances grâce au cache CDN
  - Fournir un accès mondial rapide
  - Servir le contenu en **HTTPS** avec **ACM (AWS Certificate Manager)**
- Le nom de domaine sera géré via **Route 53**

---

## 🧠 2. API Serverless avec FastAPI sur Lambda

- Le backend sera déployé sur **AWS Lambda** via **API Gateway**
- Routes exposées :
  - `POST /commentaires` → enregistrement en base
  - `GET /commentaires?sectionId=...` → affichage des commentaires
  - `GET /health` → pour les checks de disponibilité
- Connexion directe à **DynamoDB**, base NoSQL scalable et managée
- Les accès à l’API seront protégés par **API Keys**, ou **AWS Cognito** (authentification utilisateurs)

---

## 📦 3. Base de données DynamoDB

- Table principale : `CommentairesAlternance`
- Clé primaire : `id`
- Index secondaire : `sectionId + timestamp` (pour trier les commentaires)
- Requête optimisée par section, affichage des commentaires du plus récent au plus ancien

---

## 🛠️ 4. Automatisation et CI/CD

- **GitHub Actions** mettra en place un pipeline CI/CD :
  - Déploiement automatique du frontend dans S3
  - Déploiement automatique du backend dans Lambda
- Variables d’environnement et secrets gérés via **AWS Systems Manager Parameter Store**

---

## 📅 5. Sauvegarde et planification

- **EventBridge** planifiera l'exécution régulière de tâches (ex : toutes les 24h)
- Ces événements déclencheront des **Lambda** de sauvegarde :
  - Export de la table DynamoDB
  - Backup du contenu du bucket S3
- Les fichiers seront archivés dans un second bucket, ou dans **Amazon S3 Glacier** pour les sauvegardes longue durée

---

## 🔐 6. Sécurité et IAM

- Chaque service disposera de son propre **IAM Role** avec permissions strictement nécessaires
- Les accès entre Lambda, DynamoDB, S3 et EventBridge seront **autorisés par politiques précises**
- **AWS WAF** (Web Application Firewall) protègera l’API contre les attaques (ex : injections, bots)
- **CORS contrôlé** pour l’API afin de limiter les origines autorisées

---

## 📊 7. Supervision et Monitoring

- **CloudWatch Logs** pour journaliser les appels API
- **CloudWatch Metrics & Alarms** pour surveiller la charge, la latence et les erreurs
- Dashboard CloudWatch personnalisé pour visualiser l’état global du système
- Health checks automatisés via `/health` pour vérifier que tout fonctionne

---

## 🎯 Objectif final

Un projet personnel d’alternance déployé en conditions réelles, conforme aux standards de production :

- Cloud-native  
- Serverless  
- Sécurisé, résilient et automatisé  
- Entièrement documenté et versionné (GitHub)  
- Prêt à être présenté comme **cas d’usage professionnel** ou **projet de portfolio DevOps/Cloud**
