/*
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}
*/

module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  nsgs                = var.nsgs
  firewallIpPrivates  = module.firewall.private_ips
}

module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnets               = var.vnets
  subnets             = var.subnets
  nsg_ids             = module.nsg.nsg_ids
}



module "vm" {
  source              = "./modules/vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  vms                 = var.vms
  subnet_ids          = module.network.subnet_ids
}

module "public_ip" {
  source              = "./modules/PublicIP"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_ips          = var.public_ips
}


module "firewall_policy" {
  source              = "./modules/FirewallPolicy"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewall_policies   = var.firewall_policies
  public_ip_addresses = module.public_ip.public_ip_addresses
  vm_private_ips      = module.vm.vm_private_ips
}

module "firewall" {
  source              = "./modules/firewall"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewalls           = var.firewalls

  subnet_ids           = module.network.subnet_ids
  public_ip_ids        = module.public_ip.public_ip_ids
  firewall_policy_ids  = module.firewall_policy.firewall_policy_ids
}



module "vnet_peering" {
  source = "./modules/vnetPeering"
  peerings = var.peerings
  vnet_ids  = module.network.vnet_ids
}

/*

module "dns" {
  source              = "./modules/dns"
  resource_group_name = var.resource_group_name
  dns_zones            = var.dns_zones
  vnet_ids            = module.network.vnet_ids
}


module "aks" {
  source = "./modules/aks"
  
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_ids          = module.network.subnet_ids
  firewallIpPrivates  = module.firewall.private_ips
  dns_zone_ids        = module.dns.dns_zone_ids
  route       = var.route
  aks         = var.aks

}
*/

module "container_apps" {
  source = "./modules/container_apps"
  
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_name = var.log_analytics_workspace_name
  environment_name           = var.environment_name
  subnet_ids                 = module.network.subnet_ids
  container_apps             = var.container_apps
}

module "appGetWay" {
  source = "./modules/appGetWay"

  application_gateway = var.application_gateway
  subnet_ids          = module.network.subnet_ids
  location            = var.location
  resource_group_name = var.resource_group_name
  public_ip_ids       = module.public_ip.public_ip_ids
  container_app_urls  = module.container_apps.container_app_urls
}
