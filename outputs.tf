output "vnet_ids" {
  value = module.network.vnet_ids
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "nsg_ids" {
  value = module.nsg.nsg_ids
}

output "vm_ids" {
  value = module.vm.vm_ids
}

output "public_ip_ids" {
  value = module.public_ip.public_ip_ids
}

output "firewall_policy_ids" {
  //value = length(module.firewall_policy.firewall_policy_ids) > 0 ? module.firewall_policy.firewall_policy_ids : {}
   //value = try(module.firewall_policy.firewall_policy_ids, {})
   value = false && length(module.firewall_policy) > 0 ? try(module.firewall_policy[0].firewall_policy_ids, "default_value") : "default_value"
}

output "firewall_ids" {
 value = can(module.firewall.firewall_ids) ? module.firewall.firewall_ids : {}
   
  //value = length(module.firewall.firewall_ids) > 0 ? module.firewall.firewall_ids : {}
}/*
output "firewall_policy_ids" {
  value = module.firewall_policy.firewall_policy_ids
}
output "firewall_ids" {
  value = module.firewall.firewall_ids
}*/

