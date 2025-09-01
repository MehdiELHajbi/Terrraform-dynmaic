# Module Public IP - Adresses IP publiques

resource "azurerm_public_ip" "this" {
  for_each = var.public_ips
  
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = each.value.allocation_method
  zones               = each.value.zones

  tags = {
    Environment = "Hub-Spoke"
    Module      = "PublicIP"
  }
} 