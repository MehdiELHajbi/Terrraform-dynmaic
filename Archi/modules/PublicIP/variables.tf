variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "public_ips" {
  type = map(object({
    name              = string
    allocation_method = string
    zones             = list(string)
  }))
}