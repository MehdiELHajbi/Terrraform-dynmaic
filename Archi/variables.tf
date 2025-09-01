variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

# VNets Configuration
variable "vnets" {
  description = "Virtual networks configuration"
  type = map(object({
    name          = string
    address_space = list(string)
  }))
}

# Subnets Configuration
variable "subnets" {
  description = "Subnets configuration"
  type = map(object({
    name           = string
    address_prefix = string
    nsg_name       = string
    vnet_name      = string
  }))
}

# Public IPs Configuration
variable "public_ips" {
  description = "Public IPs configuration"
  type = map(object({
    name              = string
    allocation_method = string
    zones             = list(string)
  }))
}



# NSG Configuration
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
      use_firewall_ip_as_source  = optional(bool, false)
      use_firewall_ip_as_destination = optional(bool, false)
    }))
  }))
}

# VNet Peering Configuration
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

# Firewall Policies Configuration
variable "firewall_policies" {
  type = map(object({
    name                     = string
    sku_tier                 = string
    firewall_policy_priority = number
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
    nat_rules = list(object({
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
        translated_address    = string
        translated_port       = string
      }))
    }))
  }))
}

# Firewalls Configuration
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

# Container Apps Configuration
variable "container_apps" {
  description = "Container Apps configuration"
  type = object({
    subnet_name    = string
    workspace_name = string
    environment_name = string
    apps = map(object({
      container_name   = string
      image           = string
      cpu             = number
      memory          = string
      min_replicas    = number
      max_replicas    = number
      target_port     = number
      external_ingress = bool
      env_vars        = optional(map(string), {})
    }))
  })
}

# Application Gateway Configuration
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
      probe_name            = optional(string)
    }))
    probes = optional(map(object({
      interval            = number
      path                = string
      protocol            = string
      timeout             = number
      unhealthy_threshold = number
      pick_host_name_from_backend_http_settings = bool
    })), {})
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

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace used by Container Apps"
  type        = string
}

variable "environment_name" {
  description = "The name of the Container Apps environment"
  type        = string
} 