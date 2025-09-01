# 🏗️ Architecture Hub-and-Spoke - Projet RD

## 📋 **Vue d'ensemble**

Ce projet Terraform implémente une architecture **Hub-and-Spoke** simplifiée pour Azure, sans Bastion, avec un firewall centralisé et des environnements PPD et PRD séparés.

## 🎯 **Objectifs de l'architecture**

- **Sécurité centralisée** via Azure Firewall dans le Hub
- **Isolation des environnements** PPD et PRD
- **Connectivité contrôlée** entre les VNets via peering
- **Scalabilité** des applications via Container Apps
- **Load balancing** via Application Gateway

## 🏛️ **Architecture détaillée**

### **VNet Hub (10.0.0.0/16)**
- **Subnet Firewall** : Azure Firewall principal
- **Subnet Firewall Management** : Gestion du firewall
- **Rôle** : Centre de sécurité et de connectivité

### **VNet PPD (10.1.0.0/16)**
- **Subnet PPD** : Applications PPD
- **Subnet App Gateway PPD** : Load balancer PPD
- **Subnet Container Apps PPD** : Environnement conteneurisé PPD

### **VNet PRD (10.2.0.0/16)**
- **Subnet PRD** : Applications PRD
- **Subnet App Gateway PRD** : Load balancer PRD
- **Subnet Container Apps PRD** : Environnement conteneurisé PRD

## 🔗 **Flux de trafic**

```
Internet → Application Gateway → Container Apps
                ↓
            VNet Peering → Hub Firewall → Internet
```

## 📁 **Structure du projet**

```
RD/
├── main.tf                 # Configuration principale
├── variables.tf            # Définition des variables
├── terraform.tfvars        # Valeurs des variables
├── outputs.tf              # Sorties globales
├── modules/
│   ├── nsg/               # Groupes de sécurité
│   ├── network/           # VNets, Subnets, Peering
│   ├── public_ip/         # Adresses IP publiques
│   ├── firewall_policy/   # Politique du firewall
│   ├── firewall/          # Azure Firewall
│   ├── container_apps/    # Container Apps
│   └── app_gateway/       # Application Gateway
```

## 🚀 **Déploiement**

### **Prérequis**
- Azure CLI configuré
- Terraform installé
- Resource Group existant

### **Commandes de déploiement**

```bash
# Initialisation
terraform init

# Planification
terraform plan

# Déploiement
terraform apply

# Destruction (attention !)
terraform destroy
```

## ⚙️ **Configuration**

### **Variables principales**
- `location` : Région Azure
- `resource_group_name` : Nom du groupe de ressources
- `vnets` : Configuration des réseaux virtuels
- `subnets` : Configuration des sous-réseaux
- `nsgs` : Règles de sécurité réseau
- `firewall` : Configuration du firewall
- `container_apps_ppd/prd` : Applications conteneurisées
- `application_gateway_ppd/prd` : Load balancers

### **Personnalisation**
Modifiez `terraform.tfvars` pour :
- Changer les plages d'adresses IP
- Ajouter de nouvelles applications
- Modifier les règles de sécurité
- Ajuster les capacités des ressources

## 🔒 **Sécurité**

### **NSG Rules**
- **Hub** : Accès limité au management du firewall
- **PPD/PRD** : Communication HTTP entre App Gateway et Container Apps
- **Isolation** : Chaque environnement a ses propres règles

### **Firewall Rules**
- **Application Rules** : Trafic HTTP/HTTPS autorisé
- **Network Rules** : Accès Internet contrôlé
- **Source** : VNets PPD et PRD uniquement

## 📊 **Monitoring**

### **Log Analytics**
- Workspace centralisé pour tous les logs
- Rétention configurée à 30 jours
- Intégration avec Container Apps

### **Métriques disponibles**
- Trafic réseau via NSG
- Performance des Container Apps
- Utilisation du firewall
- Métriques Application Gateway

## 🔄 **Maintenance**

### **Ajout d'une nouvelle application**
1. Ajouter la configuration dans `container_apps_ppd` ou `container_apps_prd`
2. Mettre à jour les pools backend des Application Gateways
3. Appliquer avec `terraform apply`

### **Modification des règles de sécurité**
1. Modifier la section `nsgs` dans `terraform.tfvars`
2. Vérifier l'impact avec `terraform plan`
3. Appliquer les changements

## 🚨 **Points d'attention**

- **Coûts** : Le firewall et les Application Gateways ont des coûts associés
- **Performance** : Le trafic passe par le Hub, ajoutant une latence
- **Maintenance** : Les mises à jour du firewall peuvent impacter la connectivité
- **Backup** : Configurer des sauvegardes des configurations Terraform

## 📞 **Support**

Pour toute question ou problème :
1. Vérifier les logs Terraform
2. Consulter la documentation Azure
3. Vérifier la connectivité réseau
4. Contacter l'équipe DevOps

---

**Version** : 1.0  
**Date** : Août 2025  
**Auteur** : Équipe DevOps 