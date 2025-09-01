variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "public_ip_addresses" {
  type        = map(string)
  description = "Map of public IP names to their addresses"
}

variable "vm_private_ips" {
  type        = map(string)
  description = "Map of VM names to their private IP addresses"
}


variable "firewall_policies" {
  type = map(object({
    name                     = string
    sku_tier                 = string
    firewall_policy_priority = number
    application_rules        = list(object({
      name       = string
      priority   = number
      action     = string
      rule_group = list(object({
        name                  = string
        description           = string
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
        target_fqdns          = list(string)
        protocol = object({
          type = string
          port = string
        })
      }))
    }))
    network_rules = list(object({
      name       = string
      priority   = number
      action     = string
      rule_group = list(object({
        name                  = string
        description           = string
        source_addresses      = list(string)
        destination_addresses = list(string)
        protocols             = list(string)
        destination_ports     = list(string)
      }))
    }))
    nat_rules = list(object({
      name       = string
      priority   = number
      action     = string
      rule_group = list(object({
        name                  = string
        description           = string
        source_addresses      = list(string)
        destination_addresses = list(string)
        protocols             = list(string)
        destination_ports     = list(string)
        translated_address    = string
        translated_port       = string
      }))
    }))
  }))
}