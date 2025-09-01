variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure location for the firewall"
}

variable "firewall" {
  type = object({
    name                      = string
    sku_tier                  = string
    zones                     = list(string)
    subnet_name               = string
    public_ip_name            = string
    management_subnet_name    = string
    management_public_ip_name = string
  })
  description = "Firewall configuration"
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of subnet names to their IDs"
}

variable "public_ip_ids" {
  type        = map(string)
  description = "Map of public IP names to their IDs"
}

variable "firewall_policy_id" {
  type        = string
  description = "ID of the firewall policy"
} 