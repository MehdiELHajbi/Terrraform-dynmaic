
# Add this to dynamically get Container App URLs and add them to your backend pool
locals {
  container_app_hosts = var.container_app_urls != null ? values(var.container_app_urls) : []
}


resource "azurerm_application_gateway" "this" {
  name                = var.application_gateway.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.application_gateway.sku_name
    tier     = var.application_gateway.sku_tier
    capacity = var.application_gateway.capacity
  }

  gateway_ip_configuration {
    name      = "${var.application_gateway.name}-ip-config"
    subnet_id = var.subnet_ids[var.application_gateway.subnet_name]
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.application_gateway.frontend_ip_configurations
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = var.public_ip_ids[frontend_ip_configuration.value.public_ip_address_name] //lookup(frontend_ip_configuration.value, "public_ip_address_id", null)
      private_ip_address   = lookup(frontend_ip_configuration.value, "private_ip_address", null)
      subnet_id            = lookup(frontend_ip_configuration.value, "subnet_id", null)
    }
  }

  dynamic "frontend_port" {
    for_each = var.application_gateway.frontend_ports
    content {
      name = frontend_port.key
      port = frontend_port.value
    }
  }

# Update your backend_address_pool blocks to include the Container App URLs
dynamic "backend_address_pool" {
  for_each = var.application_gateway.backend_address_pools
  content {
    name = backend_address_pool.key
    # If this is the container-apps-pool, populate with the Container App URLs
    ip_addresses = backend_address_pool.key == "container-apps-pool" ? local.container_app_hosts : backend_address_pool.value
  }
}

  dynamic "backend_http_settings" {
    for_each = var.application_gateway.backend_http_settings
    content {
      name                  = backend_http_settings.key
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "http_listener" {
    for_each = var.application_gateway.http_listeners
    content {
      name                           = http_listener.key
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.application_gateway.request_routing_rules
    content {
      name                       = request_routing_rule.key
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
      priority                   = request_routing_rule.value.priority

    }
  /*depends_on = [
    azurerm_application_gateway.this.http_listener
  ]*/
  }

  tags = var.application_gateway.tags
}