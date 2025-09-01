variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
}

variable "subnets" {
  type = map(object({
    name           = string
    address_prefix = string
    nsg_name       = string
    vnet_name      = string
  }))
}

variable "nsg_ids" {
  type = map(string)
}