output "firewall_policy_id" {
  value       = azurerm_firewall_policy.this.id
  description = "ID of the firewall policy"
}

output "firewall_policy_name" {
  value       = azurerm_firewall_policy.this.name
  description = "Name of the firewall policy"
} 