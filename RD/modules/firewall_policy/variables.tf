variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure location for the firewall policy"
}

variable "firewall_policy" {
  type = object({
    name     = string
    sku_tier = string
    application_rules = list(object({
      name     = string
      priority = number
      action   = string
      rule_group = list(object({
        name                  = string
        description           = string
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
        protocol = object({
          type = string
          port = string
        })
      }))
    }))
    network_rules = list(object({
      name     = string
      priority = number
      action   = string
      rule_group = list(object({
        name                  = string
        description           = string
        source_addresses      = list(string)
        destination_addresses = list(string)
        protocols             = list(string)
        destination_ports     = list(string)
      }))
    }))
  })
  description = "Firewall Policy configuration"
} 