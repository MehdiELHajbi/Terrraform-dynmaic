variable "peerings" {
  description = "List of VNet peerings"
  type = map(object({
    name                         = string
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
  }))
}


variable "vnet_ids" {
  type = map(string)
}