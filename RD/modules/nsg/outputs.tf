
output "nsg_ids" {
  value = {
    for name, nsg in azurerm_network_security_group.this : 
      name => nsg.id
  }
  description = "Map of NSG names to their IDs"
}

output "nsg_names" {
  value = {
    for name, nsg in azurerm_network_security_group.this : 
      name => nsg.name
  }
  description = "Map of NSG names to their actual names"
} 