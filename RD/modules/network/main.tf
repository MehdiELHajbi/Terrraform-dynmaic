# Module Network - VNets, Subnets et VNet Peering

# Création des Virtual Networks
resource "azurerm_virtual_network" "this" {
  for_each            = var.vnets
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = each.value.address_space

  tags = {
    Environment = "Hub-Spoke"
    Module      = "Network"
  }
}

# Création des Subnets
resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = [each.value.address_prefix]
}

# Association des NSGs aux Subnets
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for k, v in var.subnets : k => v
    if v.nsg_name != ""
  }
  
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = var.nsg_ids[each.value.nsg_name]
}

# VNet Peering
resource "azurerm_virtual_network_peering" "this" {
  for_each = var.peerings

  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.this[each.value.remote_virtual_network_id].id

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
} 