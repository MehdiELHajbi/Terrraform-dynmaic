output "application_gateway_id" {
  value       = azurerm_application_gateway.this.id
  description = "ID of the Application Gateway"
}

output "frontend_ip_addresses" {
  value = {
    for name, config in azurerm_application_gateway.this.frontend_ip_configuration : 
      name => config.private_ip_address
  }
  description = "Map of frontend IP configuration names to their private IP addresses"
}

output "backend_address_pools" {
  value = {
    for idx, pool in azurerm_application_gateway.this.backend_address_pool : 
      pool.name => pool.id
  }
  description = "Map of backend address pool names to their IDs"
} 