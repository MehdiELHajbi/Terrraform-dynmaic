variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet_ids" {
  type = map(string)
}


variable "dns_zones" {
  description = "The configuration of the DNS zone and its records"
  type = map(object({
    name       = string
    vnet_links = list(object({
      name                 = string
      virtual_network_id   = string
      registration_enabled = bool
    }))
  }))
}
