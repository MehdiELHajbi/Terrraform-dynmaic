# Network Outputs
output "vnet_ids" {
  description = "Map of VNet IDs"
  value       = module.network.vnet_ids
}

output "subnet_ids" {
  description = "Map of Subnet IDs"
  value       = module.network.subnet_ids
}

# Firewall Outputs
output "firewall_private_ip" {
  description = "Azure Firewall private IP address"
  value       = module.firewall.private_ips["hub_fw"]
}

output "firewall_public_ip" {
  description = "Azure Firewall public IP address"
  value       = module.public_ip.public_ip_addresses["pip-firewall"]
}

# Container Apps Outputs
output "container_app_urls" {
  description = "Container Apps URLs"
  value       = module.container_apps.container_app_urls
}

# Application Gateway Outputs
output "application_gateway_public_ip" {
  description = "Application Gateway public IP address"
  value       = module.public_ip.public_ip_addresses["pip-appgw"]
}

# Resource Group Output
output "resource_group_name" {
  description = "Resource group name"
  value       = var.resource_group_name
} 