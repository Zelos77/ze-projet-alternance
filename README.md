# Projet Alternance – Infrastructure AWS avec Terraform

Ce projet définit une infrastructure AWS minimaliste mais évolutive, déployée avec Terraform, permettant d'héberger des instances dans une architecture réseau bien structurée. Il constitue une base solide pour un projet cloud évolutif.

---

## Utilisation (ne fonctionne actuellement qu'avec un compte spécifique) :
- Cloner le repo
- Dans /infra utilisez les commandes terraform init, terraform plan, terraform apply
- L'output dns_name ze-elb-projet-alternance-[ID].eu-west-3.elb.amazonaws.com/ est à utiliser en http:// afin de se connecter au load balancer.
- Le fonctionnement du load balancer est confirmé en appuyant de manière répétée sur F5 (Un site bleu et un site rouge s'alterneront)

## 🔧 Composants Principaux

### Réseau
- Un **VPC privé** configuré manuellement avec un CIDR `/24`
- Deux sous-réseaux **publics** et deux **privés**, répartis sur deux zones de disponibilité
- Une table de routage publique redirigeant le trafic vers Internet via une Internet Gateway
- Des **ACLs** configurés manuellement pour contrôler l'accès réseau (SSH, HTTP, HTTPS, ports éphémères)
- Des **Security Groups** restreints, n’autorisant que le minimum nécessaire

### Instances EC2
### Scripts de configuration des instances (user_data)

Chaque instance EC2 est automatiquement configurée grâce à un script `user_data`. Ces scripts réalisent les actions suivantes :

- Mise à jour complète du système via `dnf`
- Installation de `nginx`, `git` et `python3-pip`
- Clonage du dépôt GitHub `ze-projet-alternance` (branche `main`)
- Installation des dépendances Python pour le backend
- Déploiement du fichier HTML correspondant à l'instance :
  - `index_blue.html` pour l’instance **blue**
  - `index_red.html` pour l’instance **red**
- Démarrage et activation du service NGINX

Ces scripts assurent que chaque instance est prête à servir une page web personnalisée dès le lancement.
- Deux instances (`ze_instance_blue`, `ze_instance_red`) dans les subnets publics
- Sont intégrées au système **AWS Systems Manager (SSM)** pour l'administration sans SSH

### Load Balancer
- Un **Elastic Load Balancer (Classic)** distribue le trafic HTTP vers les deux instances
- Health checks activés pour garantir la disponibilité

### Sécurité & IAM
- Un rôle IAM avec permissions SSM est attaché à chaque instance via un **Instance Profile**

---

## 🌍 Accès
Une fois le déploiement terminé, l’output `dns_name` affiche le nom DNS du ELB, à utiliser sur le port `:80` pour accéder à l’application hébergée.
Il est possible de prouver le bon fonctionnement du loab balancer en appuyant de façon répétée sur F5.
La page changera de couleur, ce qui démontre que le site s'affiche sur une instance ou une autre.

---

## 📦 Évolution future prévue
Le code est prêt à évoluer, avec des sous-réseaux privés en place pour héberger des services non exposés (bases de données, backends, etc.). Il est également possible d’ajouter :
- Un NAT Gateway pour permettre aux instances privées de sortir vers Internet
- Des groupes Auto Scaling
- Une couche RDS/DynamoDB, S3, Lambda, eventbridge etc.

## Diagramme de l'architecture au stade actuel :
![alt text](https://github.com/Zelos77/ze-projet-alternance/blob/main/infra/diagramme.jpg?raw=true)
