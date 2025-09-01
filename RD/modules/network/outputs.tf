output "vnet_ids" {
  value = {
    for name, vnet in azurerm_virtual_network.this : 
      name => vnet.id
  }
  description = "Map of VNet names to their IDs"
}

output "subnet_ids" {
  value = {
    for name, subnet in azurerm_subnet.this : 
      name => subnet.id
  }
  description = "Map of subnet names to their IDs"
}

output "vnet_names" {
  value = {
    for name, vnet in azurerm_virtual_network.this : 
      name => vnet.name
  }
  description = "Map of VNet names to their actual names"
}

output "subnet_names" {
  value = {
    for name, subnet in azurerm_subnet.this : 
      name => subnet.name
  }
  description = "Map of subnet names to their actual names"
} 