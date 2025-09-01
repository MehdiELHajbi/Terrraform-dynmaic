# 🚀 **Démonstration du Projet RD - Hub-and-Spoke**

## 📋 **Scénario de démonstration**

Ce projet démontre une architecture Hub-and-Spoke complète avec :
- **3 VNets** : Hub, PPD, PRD
- **Firewall centralisé** pour la sécurité
- **Container Apps** pour la scalabilité
- **Application Gateway** pour le load balancing

## 🎯 **Objectifs de la démo**

1. **Déployer l'infrastructure** complète
2. **Tester la connectivité** entre les environnements
3. **Valider la sécurité** via le firewall
4. **Démontrer la scalabilité** des Container Apps

## 🚀 **Étapes de démonstration**

### **Étape 1 : Préparation**
```bash
# Se connecter à Azure
az login

# Vérifier le contexte
az account show

# Créer le resource group (si nécessaire)
az group create --name rg-hub-spoke-rd --location "East US"
```

### **Étape 2 : Déploiement Terraform**
```bash
# Aller dans le dossier RD
cd RD

# Initialiser Terraform
terraform init

# Vérifier le plan
terraform plan

# Déployer l'infrastructure
terraform apply -auto-approve
```

### **Étape 3 : Validation de l'infrastructure**
```bash
# Vérifier les VNets créés
az network vnet list --resource-group rg-hub-spoke-rd

# Vérifier les Container Apps
az containerapp list --resource-group rg-hub-spoke-rd

# Vérifier les Application Gateways
az network application-gateway list --resource-group rg-hub-spoke-rd
```

### **Étape 4 : Test de connectivité**
```bash
# Récupérer les IPs publiques
terraform output app_gateway_frontend_ips

# Tester l'accès aux applications
curl http://<IP_APP_GATEWAY_PPD>
curl http://<IP_APP_GATEWAY_PRD>
```

## 🔍 **Points de validation**

### **Architecture réseau**
- ✅ **3 VNets** créés avec les bonnes plages d'adresses
- ✅ **Peering** configuré entre tous les VNets
- ✅ **Subnets** correctement associés aux NSGs

### **Sécurité**
- ✅ **Firewall** déployé dans le Hub
- ✅ **NSG Rules** appliquées correctement
- ✅ **Isolation** entre environnements PPD et PRD

### **Applications**
- ✅ **Container Apps** déployées et accessibles
- ✅ **Application Gateways** configurés et fonctionnels
- ✅ **Load balancing** opérationnel

## 📊 **Métriques à surveiller**

### **Performance réseau**
```bash
# Latence entre VNets
az network watcher test-connectivity \
  --resource-group rg-hub-spoke-rd \
  --source-resource <VM_PPD_ID> \
  --dest-resource <VM_PRD_ID>
```

### **Utilisation du firewall**
```bash
# Logs du firewall
az monitor activity-log list \
  --resource-group rg-hub-spoke-rd \
  --resource-type "Microsoft.Network/azureFirewalls"
```

### **Métriques Container Apps**
```bash
# Réplicas actifs
az monitor metrics list \
  --resource <CONTAINER_APP_ID> \
  --metric "ReplicaCount"
```

## 🧪 **Tests de charge**

### **Test simple avec curl**
```bash
# Test de charge basique
for i in {1..100}; do
  curl -s http://<IP_APP_GATEWAY_PPD> > /dev/null &
done
wait
```

### **Test avec Apache Bench (si disponible)**
```bash
# Test de charge avec ab
ab -n 1000 -c 10 http://<IP_APP_GATEWAY_PRD>/
```

## 🔧 **Dépannage courant**

### **Problème de connectivité**
```bash
# Vérifier les NSG Rules
az network nsg rule list \
  --resource-group rg-hub-spoke-rd \
  --nsg-name <NSG_NAME>

# Vérifier le peering
az network vnet peering list \
  --resource-group rg-hub-spoke-rd \
  --vnet-name <VNET_NAME>
```

### **Problème de Container Apps**
```bash
# Vérifier les logs
az containerapp logs show \
  --resource-group rg-hub-spoke-rd \
  --name <APP_NAME>

# Vérifier l'état
az containerapp show \
  --resource-group rg-hub-spoke-rd \
  --name <APP_NAME>
```

## 📈 **Scaling des applications**

### **Augmenter les réplicas**
```bash
# Modifier terraform.tfvars
# Changer max_replicas de 3 à 10

# Appliquer les changements
terraform apply
```

### **Ajouter une nouvelle application**
```bash
# Ajouter dans terraform.tfvars
"app-ppd-3" = {
  container_name   = "app-ppd-3"
  image           = "nginx:latest"
  cpu             = 0.5
  memory          = "1Gi"
  min_replicas    = 1
  max_replicas    = 5
  target_port     = 80
  external_ingress = false
}

# Appliquer
terraform apply
```

## 🧹 **Nettoyage**

### **Supprimer l'infrastructure**
```bash
# Destruction complète
terraform destroy -auto-approve

# Vérifier la suppression
az group show --name rg-hub-spoke-rd
```

## 📚 **Ressources additionnelles**

- **Documentation Azure** : [Hub-and-Spoke Architecture](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
- **Terraform Azure Provider** : [Documentation officielle](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- **Container Apps** : [Documentation Azure](https://docs.microsoft.com/en-us/azure/container-apps/)

---

**🎉 Félicitations !** Vous avez déployé une architecture Hub-and-Spoke complète et fonctionnelle ! 