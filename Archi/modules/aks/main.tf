data "azuread_client_config" "current" {}

resource "azuread_group" "example" {
  display_name     = "grp-aks" //var.azuread_grp_name
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_group_member" "example_member" {
  group_object_id  = azuread_group.example.id
  member_object_id = data.azuread_client_config.current.object_id
}
resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "aks-prod-identity"
}

/*
resource "azuread_application" "aks_app" {
  display_name = "aks-sp"
}

resource "azuread_service_principal" "aks_sp" {
  application_id = azuread_application.aks_app.application_id
}

resource "azuread_service_principal_password" "aks_sp_password" {
  service_principal_id = azuread_service_principal.aks_sp.object_id
  end_date             = "2099-01-01T00:00:00Z"
}

# Rechercher le service principal par son client_id
data "azuread_service_principal" "aks" {
  application_id = azuread_application.aks_app.application_id
}
*/


# Création de la table de routage
resource "azurerm_route_table" "aks_route_table" {
  name                = "rt-aks-prd"
  location            = var.aks.location
  resource_group_name = var.resource_group_name

  # Vous pouvez ajouter des routes spécifiques ici si nécessaire
   route {
     name                   = var.route.name //"aksToFirwall"
     address_prefix         = var.route.address_prefix //"0.0.0.0/0"  # destionation internet
     next_hop_type          = "VirtualAppliance"
     next_hop_in_ip_address = var.firewallIpPrivates[var.route.next_hop_in_ip_address] //"10.0.2.4"   # il doit passer passer par le firewall (ip privé ) pour sortir a internet
   }
}

# Association de la table de routage au sous-réseau
resource "azurerm_subnet_route_table_association" "aks_subnet_route_table_association" {
  subnet_id      = var.subnet_ids[var.aks.subnet_name]
  route_table_id = azurerm_route_table.aks_route_table.id
}
/*/*
#Créez une identité gérée par l'utilisateur :
resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "aks-identity"
}



*/


resource "azurerm_role_assignment" "aks_dns_contributor" {
  scope                = var.dns_zone_ids[var.aks.private_dns_zone_id]
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = var.dns_zone_ids[var.aks.private_dns_zone_id]
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

# creation aks
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks.cluster_name
  location            = var.aks.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks.dns_prefix
  private_dns_zone_id = length(var.dns_zone_ids) > 0 ? var.dns_zone_ids[var.aks.private_dns_zone_id] : null
  kubernetes_version  = var.aks.kubernetes_version
  private_cluster_enabled = true

  default_node_pool {
    name           = "default"
    node_count     = var.aks.node_count
    vm_size        = var.aks.vm_size
    os_disk_size_gb = 30//var.cluster_default_node_pool_os_disk_size_gb
    vnet_subnet_id = var.subnet_ids[var.aks.subnet_name]
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = [azuread_group.example.id]
  }
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

 identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }



  
/*
  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.aks.dns_service_ip
   // docker_bridge_cidr = var.aks.docker_bridge_cidr
    service_cidr       = var.aks.service_cidr
    outbound_type      = "userDefinedRouting"
  }


 identity {
    type = "SystemAssigned"
  }
 */

/*
  service_principal {
    client_id     = azuread_application.aks_app.application_id
    client_secret = azuread_service_principal_password.aks_sp_password.value
  }

 identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

 
  */

  tags = var.aks.tags
}

/*
Voici les étapes principales du processus :

Créer l'Identité Assignée par l'Utilisateur : Vous créez une ressource azurerm_user_assigned_identity pour l'identité AKS.
Assigner les Permissions : Vous utilisez azurerm_role_assignment pour donner à cette identité les permissions nécessaires, comme le rôle Private DNS Zone Contributor pour interagir avec les DNS privés.
Configurer AKS pour Utiliser cette Identité : Vous spécifiez l'identité assignée par l'utilisateur dans la configuration AKS sous le bloc identity.
*/