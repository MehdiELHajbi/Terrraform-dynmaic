output "container_app_environment_id" {
  value       = azurerm_container_app_environment.this.id
  description = "ID of the Container App environment"
}

output "container_app_urls" {
  value = {
    for name, app in azurerm_container_app.this : 
      name => app.latest_revision_fqdn
  }
  description = "FQDNs for the deployed Container Apps"
}

output "container_app_ids" {
  value = {
    for name, app in azurerm_container_app.this : 
      name => app.id
  }
  description = "IDs of the deployed Container Apps"
} 