variable "location" {
  type        = string
  description = "Azure location for all resources"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
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

variable "nsgs" {
  type = map(object({
    name  = string
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  description = "Map of Network Security Groups"
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
  description = "Azure Firewall configuration"
}

variable "firewall_policy" {
  type = object({
    name                     = string
    sku_tier                 = string
    application_rules        = list(object({
      name       = string
      priority   = number
      action     = string
      rule_group = list(object({
        name                  = string
        description           = string
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
        target_fqdns          = list(string)
        protocol = object({
          type = string
          port = string
        })
      }))
    }))
    network_rules = list(object({
      name       = string
      priority   = number
      action     = string
      rule_group = list(object({
        name                  = string
        description           = string
        source_addresses      = list(string)
        destination_addresses = list(string)
        protocols             = list(string)
        destination_ports     = list(string)
      }))
    }))
  })
  description = "Firewall Policy configuration"
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

variable "container_apps_ppd" {
  type = object({
    subnet_name = string
    apps = map(object({
      container_name   = string
      image           = string
      cpu             = number
      memory          = string
      min_replicas    = number
      max_replicas    = number
      target_port     = number
      external_ingress = bool
      env_vars        = optional(map(string))
    }))
  })
  description = "Container Apps configuration for PPD environment"
}

variable "container_apps_prd" {
  type = object({
    subnet_name = string
    apps = map(object({
      container_name   = string
      image           = string
      cpu             = number
      memory          = string
      min_replicas    = number
      max_replicas    = number
      target_port     = number
      external_ingress = bool
      env_vars        = optional(map(string))
    }))
  })
  description = "Container Apps configuration for PRD environment"
}

variable "application_gateway_ppd" {
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
  description = "Application Gateway configuration for PPD environment"
}

variable "application_gateway_prd" {
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
  description = "Application Gateway configuration for PRD environment"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics workspace"
}

variable "environment_name_ppd" {
  type        = string
  description = "Name of the Container Apps environment for PPD"
}

variable "environment_name_prd" {
  type        = string
  description = "Name of the Container Apps environment for PRD"
} 