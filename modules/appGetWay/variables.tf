variable "application_gateway" {
  description = "Configuration for the Application Gateway"
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
}

variable "resource_group_name" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
  description = "Map of subnet names to subnet IDs"
}

variable "location" {
  type = string
}

variable "public_ip_ids" {
  type = map(string)
}

variable "container_app_urls" {
  description = "Map of container app names to their URLs"
  type        = map(string)
  default     = null
}