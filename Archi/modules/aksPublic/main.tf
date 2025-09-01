//------------  il faut ajouter un node pool  pour l application là on a creé juste le node pole sys ()
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aksPublic.cluster_name
  location            = var.aksPublic.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aksPublic.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}
/*
resource "azurerm_private_endpoint" "aks_pe" {
  name                = "${var.aksPublic.cluster_name}-pe"
  location            = var.aksPublic.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_ids[var.aksPublic.subnet_name]

  private_service_connection {
    name                           = "${var.aksPublic.cluster_name}-psc"
    private_connection_resource_id = azurerm_kubernetes_cluster.aks.id
    is_manual_connection           = false
    subresource_names              = ["management"]
  }
}
*/

/*resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks.cluster_name
  location            = var.aks.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks.dns_prefix
  kubernetes_version  = var.aks.kubernetes_version

  default_node_pool {
    name           = "default"
    node_count     = var.aks.node_count
    vm_size        = var.aks.vm_size
    //os_disk_size_gb = 30//var.cluster_default_node_pool_os_disk_size_gb
    vnet_subnet_id = var.subnet_ids[var.aks.subnet_name]
    vm_size    = "Standard_DS2_v2"
  }

  

  identity {
    type = "SystemAssigned"
  }

  api_server_access_profile {
    authorized_ip_ranges = ["YOUR_IP_RANGE"]
  }

  //api_server_authorized_ip_ranges = ["<your-public-ip>/32"]  # Restreindre l'accès à l'API

  network_profile {
    network_plugin = "azure"
    outbound_type     = "userDefinedRouting"
  }

  tags = {
    environment = "production"
    project     = "my-project"
  }
}
*/