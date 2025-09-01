output "id" {
  description = "The ID of the Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "backend_address_pool_ids" {
  description = "A map of Backend Address Pool names to their IDs"
  value       = { for pool in azurerm_application_gateway.this.backend_address_pool : pool.name => pool.id }
}

output "frontend_ip_configuration" {
  description = "The Frontend IP Configurations of the Application Gateway"
  value       = azurerm_application_gateway.this.frontend_ip_configuration
}