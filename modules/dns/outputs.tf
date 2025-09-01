output "dns_zone_ids" {
  description = "IDs of the DNS zones created"
  value = { for k, v in azurerm_private_dns_zone.this : k => v.id }
}
