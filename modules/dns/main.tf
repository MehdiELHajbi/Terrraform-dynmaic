resource "azurerm_private_dns_zone" "this" {
  for_each            = var.dns_zones
  name                = each.value.name
  resource_group_name = var.resource_group_name
}



resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  for_each = {
    for entry in flatten([
      for zone_name, zone_data in var.dns_zones : [
        for idx, vnet_link in zone_data.vnet_links : {
          key = "${zone_name}-${idx}"
          name = vnet_link.name
          private_dns_zone_name = azurerm_private_dns_zone.this[zone_name].name
          virtual_network_id = var.vnet_ids[vnet_link.virtual_network_id]
          registration_enabled = vnet_link.registration_enabled
        }
      ]
    ]) : entry.key => entry
  }

  name                  = each.value.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = each.value.private_dns_zone_name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = each.value.registration_enabled
}

/*
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  for_each = var.dns_zones

  name                  = each.value.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name

  dynamic "vnet_link" {
    for_each = each.value.vnet_links
    content {
      name                 = vnet_link.value.name
      virtual_network_id    = var.vnet_ids[each.value.virtual_network_id]
      registration_enabled = vnet_link.value.registration_enabled
    }
  }
}*/