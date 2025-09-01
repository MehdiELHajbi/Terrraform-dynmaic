variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure location for the Application Gateway"
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of subnet names to subnet IDs"
}

variable "public_ip_ids" {
  type        = map(string)
  description = "Map of public IP names to their IDs"
}

variable "container_app_urls" {
  type        = map(string)
  description = "Map of container app names to their URLs"
}

variable "application_gateway" {
  type = object({
    name       = string
    sku_name   = string
    sku_tier   = string
    capacity   = number
    subnet_name = string
    frontend_ip_configurations = map(object({
      name                 = string
      public_ip_address_name = optional(string)
      private_ip_address   = optional(string)
      subnet_id            = optional(string)
    }))
    frontend_ports = map(number)
    backend_address_pools = map(list(string))
    backend_http_settings = map(object({
      cookie_based_affinity = string
      port                  = number
      protocol              = string
      request_timeout       = number
    }))
    http_listeners = map(object({
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
    }))
    request_routing_rules = map(object({
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
      priority                   = number
    }))
    tags = map(string)
  })
  description = "Application Gateway configuration"
} 