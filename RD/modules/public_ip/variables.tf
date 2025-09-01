variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure location for the public IPs"
}

variable "public_ips" {
  type = map(object({
    name              = string
    allocation_method = string
    zones             = list(string)
  }))
  description = "Map of public IP configurations"
} 