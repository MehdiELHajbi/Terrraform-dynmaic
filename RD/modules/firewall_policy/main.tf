
# Module Firewall Policy - Politique du firewall Azure

resource "azurerm_firewall_policy" "this" {
  name                = var.firewall_policy.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.firewall_policy.sku_tier

  tags = {
    Environment = "Hub-Spoke"
    Module      = "FirewallPolicy"
  }
}

# Règles d'application
resource "azurerm_firewall_policy_rule_collection_group" "application_rules" {
  for_each = { for idx, rule in var.firewall_policy.application_rules : rule.name => rule }

  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = each.value.priority

  application_rule_collection {
    name     = each.value.name
    priority = each.value.priority
    action   = each.value.action

    dynamic "rule" {
      for_each = each.value.rule_group
      content {
        name                  = rule.value.name
        description           = rule.value.description
        source_addresses      = rule.value.source_addresses
        destination_addresses = rule.value.destination_addresses
        protocols {
          type = rule.value.protocol.type
          port = rule.value.protocol.port
        }
      }
    }
  }
}

# Règles réseau
resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  for_each = { for idx, rule in var.firewall_policy.network_rules : rule.name => rule }

  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = each.value.priority

  network_rule_collection {
    name     = each.value.name
    priority = each.value.priority
    action   = each.value.action

    dynamic "rule" {
      for_each = each.value.rule_group
      content {
        name                  = rule.value.name
        description           = rule.value.description
        source_addresses      = rule.value.source_addresses
        destination_addresses = rule.value.destination_addresses
        protocols             = rule.value.protocols
        destination_ports     = rule.value.destination_ports
      }
    }
  }
} 