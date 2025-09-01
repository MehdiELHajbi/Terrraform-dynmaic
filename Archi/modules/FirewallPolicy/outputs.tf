output "firewall_policy_ids" {
  value = { for k, v in azurerm_firewall_policy.this : k => v.id }
}