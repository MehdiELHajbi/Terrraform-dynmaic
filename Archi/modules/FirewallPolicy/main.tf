resource "azurerm_firewall_policy" "this" {
  for_each            = var.firewall_policies
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = each.value.sku_tier
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  for_each           = var.firewall_policies
  name               = "${each.value.name}-rule-collection-group"
  firewall_policy_id = azurerm_firewall_policy.this[each.key].id
  priority           = each.value.firewall_policy_priority

  dynamic "application_rule_collection" {
    for_each = each.value.application_rules
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rule_group
        content {
          name              = rule.value.name
          description       = rule.value.description
          source_addresses  = rule.value.source_addresses
          destination_fqdns = rule.value.target_fqdns

          protocols {
            type = rule.value.protocol.type
            port = rule.value.protocol.port
          }
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = each.value.network_rules
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rule_group
        content {
          name                  = rule.value.name
          description           = rule.value.description
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }

 dynamic "nat_rule_collection" {
    for_each = each.value.nat_rules
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rule_group
        content {
          name                = rule.value.name
          description         = rule.value.description
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          destination_address = var.public_ip_addresses[rule.value.destination_addresses[0]]
          destination_ports   = rule.value.destination_ports
          translated_address  = var.vm_private_ips[rule.value.translated_address]
          translated_port     = rule.value.translated_port
        }
      }
    }
  }

  depends_on = [azurerm_firewall_policy.this]
}