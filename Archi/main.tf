# NSG Module (pour les règles de sécurité basiques)
module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  nsgs                = var.nsgs
  firewallIpPrivates  = {}
}

# Virtual Networks Module
module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnets               = var.vnets
  subnets             = var.subnets
  nsg_ids             = module.nsg.nsg_ids
}

# Public IPs Module
module "public_ip" {
  source              = "./modules/PublicIP"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_ips          = var.public_ips
}

# Firewall Policy Module
module "firewall_policy" {
  source              = "./modules/FirewallPolicy"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewall_policies   = var.firewall_policies
  public_ip_addresses = module.public_ip.public_ip_addresses
  vm_private_ips      = {}
}

# Azure Firewall Module
module "firewall" {
  source              = "./modules/Firewall"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewalls           = var.firewalls
  subnet_ids          = module.network.subnet_ids
  public_ip_ids       = module.public_ip.public_ip_ids
  firewall_policy_ids = module.firewall_policy.firewall_policy_ids
}

# VNet Peering Module
module "vnet_peering" {
  source   = "./modules/vnetPeering"
  peerings = var.peerings
  vnet_ids = module.network.vnet_ids
}

# Container Apps Module
module "container_apps" {
  source = "./modules/container_apps"
  
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_name = var.log_analytics_workspace_name
  environment_name           = var.environment_name
  subnet_ids                 = module.network.subnet_ids
  container_apps             = var.container_apps
}

# Application Gateway Module
module "appGetWay" {
  source = "./modules/appGetWay"

  application_gateway = var.application_gateway
  subnet_ids          = module.network.subnet_ids
  location            = var.location
  resource_group_name = var.resource_group_name
  public_ip_ids       = module.public_ip.public_ip_ids
  container_app_urls  = module.container_apps.container_app_urls
} 