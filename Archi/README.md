# Architecture Hub and Spoke Simplifiée

Cette architecture implémente un modèle Hub and Spoke simple avec Azure Container Apps.

## 🏗️ Architecture

### Hub (VNet Hub - 10.0.0.0/16)
- **Azure Firewall** avec politique de sécurité basique
- **Subnets :**
  - `AzureFirewallSubnet` (10.0.1.0/26)
  - `AzureFirewallManagementSubnet` (10.0.2.0/26)

### Spoke (VNet Spoke - 10.1.0.0/16)
- **Container Apps** avec applications conteneurisées
- **Application Gateway** pour l'exposition des applications
- **Subnets :**
  - `subnet-container-apps` (10.1.0.0/23) - pour les Container Apps
  - `subnet-appgw` (10.1.2.0/24) - pour l'Application Gateway

### Connectivité
- **VNet Peering** bidirectionnel entre Hub et Spoke
- **NSG** basiques pour la sécurité réseau

## 📦 Composants déployés

1. **Réseaux :**
   - 2 VNets avec peering
   - 4 Subnets avec NSG
   - 3 IPs publiques

2. **Sécurité :**
   - Azure Firewall Basic
   - Politique de pare-feu avec règles de base
   - NSG pour Container Apps et Application Gateway

3. **Applications :**
   - Environment Container Apps
   - 2 Container Apps (web-app, api-app)
   - Application Gateway pour exposition

## 🚀 Déploiement

```bash
# Initialiser Terraform
terraform init

# Planifier le déploiement
terraform plan

# Appliquer la configuration
terraform apply
```

## 🔧 Configuration

Les fichiers principaux :
- `conf.tf` - Configuration Terraform et provider
- `variables.tf` - Définition des variables
- `terraform.tfvars` - Valeurs des variables
- `main.tf` - Ressources principales
- `outputs.tf` - Sorties Terraform

## 📊 Modules utilisés

Réutilise les modules existants du dossier `modules/` :
- `network` - VNets et subnets
- `nsg` - Network Security Groups
- `PublicIP` - Adresses IP publiques
- `FirewallPolicy` - Politique de pare-feu
- `Firewall` - Azure Firewall
- `vnetPeering` - Peering de VNets
- `container_apps` - Azure Container Apps
- `appGetWay` - Application Gateway

## 🌐 Accès aux applications

Une fois déployé :
- Applications Container Apps accessibles via Application Gateway
- Trafic routé via Azure Firewall depuis Internet
- Monitoring via Log Analytics Workspace

## 📝 Notes

- Architecture simplifiée pour démonstration
- Utilise des règles de sécurité basiques
- Configuré pour un environnement de test/développement 