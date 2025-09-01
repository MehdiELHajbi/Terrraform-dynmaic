resource "azurerm_public_ip" "this" {
  for_each            = var.public_ips
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = "Standard"
  zones               = each.value.zones
}