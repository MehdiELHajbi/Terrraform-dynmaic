resource "azurerm_virtual_network" "this" {
  for_each            = var.vnets
  name                = each.value.name
  address_space       = each.value.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_name].name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = { for k, v in var.subnets : k => v if v.nsg_name != "" }
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = var.nsg_ids[each.value.nsg_name]
}