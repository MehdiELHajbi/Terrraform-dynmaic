variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure location for the network resources"
}

variable "vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
  description = "Map of virtual networks"
}

variable "subnets" {
  type = map(object({
    name           = string
    address_prefix = string
    nsg_name       = string
    vnet_name      = string
  }))
  description = "Map of subnets"
}

variable "nsg_ids" {
  type        = map(string)
  description = "Map of NSG names to their IDs"
}

variable "peerings" {
  type = map(object({
    name                         = string
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
  }))
  description = "VNet peering configurations"
} 