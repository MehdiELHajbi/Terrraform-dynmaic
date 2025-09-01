output "firewall_ids" {
  value = {
    "firewall" = azurerm_firewall.this.id
  }
  description = "Map of firewall names to their IDs"
}

output "firewall_private_ips" {
  value = {
    "firewall" = azurerm_firewall.this.ip_configuration[0].private_ip_address
  }
  description = "Map of firewall names to their private IPs"
} 