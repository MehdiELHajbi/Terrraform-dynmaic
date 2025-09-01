resource "azurerm_firewall" "this" {
  for_each            = var.firewalls
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_tier            = each.value.sku_tier
  sku_name = "AZFW_VNet"
  firewall_policy_id  = var.firewall_policy_ids[each.value.firewall_policy_name]

  ip_configuration {
    name                 = "ip_configuration"
    subnet_id            = var.subnet_ids[each.value.subnet_name]
    public_ip_address_id = var.public_ip_ids[each.value.public_ip_name]
  }

  management_ip_configuration {
    name                 = "management_ip_configuration"
    subnet_id            = var.subnet_ids[each.value.management_subnet_name]
    public_ip_address_id = var.public_ip_ids[each.value.management_public_ip_name]
  }

  zones = each.value.zones
}