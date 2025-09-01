variable "location" {
  type = string
}

variable "resource_group_name" {
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
      use_firewall_ip_as_source  = optional(bool, false) # Valeur par défaut false
      use_firewall_ip_as_destination = optional(bool, false) # Valeur par défaut false
    }))
  }))
}

variable "vms" {
  type = map(object({
    vm_name                      = string
    vm_size                      = string
    admin_username               = string
    subnet_name                  = string
    ssh_public_key               = string
    nic_ip_configuration_name    = string
    private_ip_address_allocation = string
    os_disk_caching              = string
    os_disk_storage_account_type = string
    image_publisher              = string
    image_offer                  = string
    image_sku                    = string
    image_version                = string
  }))
}

variable "public_ips" {
  type = map(object({
    name              = string
    allocation_method = string
    zones             = list(string)
  }))
}

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

variable "aks" {
  description = "Objet contenant toutes les configurations AKS"
  type = object({
    cluster_name        = string
    location            = string
    dns_prefix          = string
    private_dns_zone_id = string
    kubernetes_version  = string
    node_count          = number
    vm_size             = string
    subnet_name         = string
    dns_service_ip      = string
    service_cidr        = string
    tags                = map(string)
  })
}

variable "aksPublic" {
  description = "Objet contenant toutes les configurations AKS"
  type = object({
    cluster_name        = string
    location            = string
    dns_prefix          = string
    subnet_name         = string
  })
}


variable "route" {
  description = "Objet contenant route table aks firwall"
  type = object({
    name                   = string
    address_prefix         = string  # destionation internet
    next_hop_in_ip_address = string   # il doit passer passer par le firewall (ip privé ) pour sortir a internet
  })
}


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


variable "dns_zones" {
  description = "Map of DNS zones and their associated configurations"
  type = map(object({
    name       = string
    vnet_links = list(object({
      name                 = string
      virtual_network_id   = string
      registration_enabled = bool
    }))
  }))
}


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

variable "container_apps" {
  description = "Configuration for Azure Container Apps"
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
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace used by Container Apps"
  type        = string
}

variable "environment_name" {
  description = "The name of the Container Apps environment"
  type        = string
}