# Configuration principale pour l'architecture Hub-and-Spoke
# RD - Hub and Spoke sans Bastion

# Module NSG - Groupes de sécurité réseau
module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  nsgs                = var.nsgs
}

# Module Network - VNets, Subnets et Peering
module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnets               = var.vnets
  subnets             = var.subnets
  nsg_ids             = module.nsg.nsg_ids
  peerings            = var.peerings
}

# Module Public IP - Adresses IP publiques
module "public_ip" {
  source              = "./modules/public_ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_ips = {
    "pip-fw-hub" = {
      name              = "pip-fw-hub"
      allocation_method = "Static"
      zones             = ["1", "2", "3"]
    }
    "pip-fw-hub-mgmt" = {
      name              = "pip-fw-hub-mgmt"
      allocation_method = "Static"
      zones             = ["1", "2", "3"]
    }
    "pip-appgw-ppd" = {
      name              = "pip-appgw-ppd"
      allocation_method = "Static"
      zones             = ["1", "2", "3"]
    }
    "pip-appgw-prd" = {
      name              = "pip-appgw-prd"
      allocation_method = "Static"
      zones             = ["1", "2", "3"]
    }
  }
}

# Module Firewall Policy - Politique du firewall
module "firewall_policy" {
  source              = "./modules/firewall_policy"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewall_policy     = var.firewall_policy
}

# Module Firewall - Azure Firewall
module "firewall" {
  source              = "./modules/firewall"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewall            = var.firewall
  subnet_ids          = module.network.subnet_ids
  public_ip_ids       = module.public_ip.public_ip_ids
  firewall_policy_id  = module.firewall_policy.firewall_policy_id
}

# Module Container Apps PPD
module "container_apps_ppd" {
  source = "./modules/container_apps"
  
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_name = var.log_analytics_workspace_name
  environment_name           = var.environment_name_ppd
  subnet_ids                 = module.network.subnet_ids
  container_apps             = var.container_apps_ppd
}

# Module Container Apps PRD
module "container_apps_prd" {
  source = "./modules/container_apps"
  
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_name = var.log_analytics_workspace_name
  environment_name           = var.environment_name_prd
  subnet_ids                 = module.network.subnet_ids
  container_apps             = var.container_apps_prd
}

# Module Application Gateway PPD
module "app_gateway_ppd" {
  source = "./modules/app_gateway"

  application_gateway = var.application_gateway_ppd
  subnet_ids          = module.network.subnet_ids
  location            = var.location
  resource_group_name = var.resource_group_name
  public_ip_ids       = module.public_ip.public_ip_ids
  container_app_urls  = module.container_apps_ppd.container_app_urls
}

# Module Application Gateway PRD
module "app_gateway_prd" {
  source = "./modules/app_gateway"

  application_gateway = var.application_gateway_prd
  subnet_ids          = module.network.subnet_ids
  location            = var.location
  resource_group_name = var.resource_group_name
  public_ip_ids       = module.public_ip.public_ip_ids
  container_app_urls  = module.container_apps_prd.container_app_urls
} 