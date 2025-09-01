variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewalls" {
  type = map(object({
    name                      = string
    sku_tier                  = string
    zones                     = list(string)
    subnet_name               = string
    public_ip_name            = string
    management_subnet_name    = string
    management_public_ip_name = string
    firewall_policy_name      = string
  }))
}

variable "subnet_ids" {
  type = map(string)
}

variable "public_ip_ids" {
  type = map(string)
}

variable "firewall_policy_ids" {
  type = map(string)
}