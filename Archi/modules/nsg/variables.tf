variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewallIpPrivates" {
  type = map(string)
  description = "Map of firewall names to firewall Ips"
  default     = {}  # Une map vide comme valeur par défaut
}

variable "nsgs" {
  type = map(object({
    name  = string
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
      use_firewall_ip_as_source  = optional(bool, false) # Valeur par défaut false
      use_firewall_ip_as_destination = optional(bool, false) # Valeur par défaut false
    }))
  }))
}