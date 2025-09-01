# Module Firewall - Azure Firewall

resource "azurerm_firewall" "this" {
  name                = var.firewall.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.firewall.sku_tier == "Premium" ? "AZFW_VNet" : "AZFW_Hub"
  sku_tier            = var.firewall.sku_tier
  zones               = var.firewall.zones

  # Configuration IP
  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = var.subnet_ids[var.firewall.subnet_name]
    public_ip_address_id = var.public_ip_ids[var.firewall.public_ip_name]
  }

  # Configuration de gestion
  management_ip_configuration {
    name                 = "management_ipconfig"
    subnet_id            = var.subnet_ids[var.firewall.management_subnet_name]
    public_ip_address_id = var.public_ip_ids[var.firewall.management_public_ip_name]
  }

  # Politique du firewall
  firewall_policy_id = var.firewall_policy_id

  tags = {
    Environment = "Hub-Spoke"
    Module      = "Firewall"
  }
} 