output "public_ip_ids" {
  value = {
    for name, pip in azurerm_public_ip.this : 
      name => pip.id
  }
  description = "Map of public IP names to their IDs"
}

output "public_ip_addresses" {
  value = {
    for name, pip in azurerm_public_ip.this : 
      name => pip.ip_address
  }
  description = "Map of public IP names to their IP addresses"
} 