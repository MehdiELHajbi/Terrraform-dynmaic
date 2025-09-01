output "firewall_ids" {
  value = { for k, v in azurerm_firewall.this : k => v.id }
}

output "private_ips" {
  value = { for k, v in azurerm_firewall.this : k => v.ip_configuration[0].private_ip_address }
}