# Sorties globales pour l'architecture Hub-and-Spoke

# IDs des VNets
output "vnet_ids" {
  value = module.network.vnet_ids
  description = "IDs des Virtual Networks créés"
}

# IDs des Subnets
output "subnet_ids" {
  value = module.network.subnet_ids
  description = "IDs des Subnets créés"
}

# IDs des NSGs
output "nsg_ids" {
  value = module.nsg.nsg_ids
  description = "IDs des Network Security Groups créés"
}

# IDs des Public IPs
output "public_ip_ids" {
  value = module.public_ip.public_ip_ids
  description = "IDs des adresses IP publiques créées"
}

# ID de la Firewall Policy
output "firewall_policy_id" {
  value = module.firewall_policy.firewall_policy_id
  description = "ID de la politique du firewall"
}

# IDs des Firewalls
output "firewall_ids" {
  value = module.firewall.firewall_ids
  description = "IDs des firewalls créés"
}

# URLs des Container Apps PPD
output "container_app_urls_ppd" {
  value = module.container_apps_ppd.container_app_urls
  description = "URLs des Container Apps PPD"
}

# URLs des Container Apps PRD
output "container_app_urls_prd" {
  value = module.container_apps_prd.container_app_urls
  description = "URLs des Container Apps PRD"
}

# Frontend IPs des Application Gateways
output "app_gateway_frontend_ips" {
  value = {
    ppd = module.app_gateway_ppd.frontend_ip_addresses
    prd = module.app_gateway_prd.frontend_ip_addresses
  }
  description = "Adresses IP frontend des Application Gateways"
}

# URLs des Application Gateways
output "app_gateway_urls" {
  value = {
    ppd = "http://${values(module.app_gateway_ppd.frontend_ip_addresses)[0]}"
    prd = "http://${values(module.app_gateway_prd.frontend_ip_addresses)[0]}"
  }
  description = "URLs d'accès aux Application Gateways"
} 