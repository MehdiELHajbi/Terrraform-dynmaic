# Module Application Gateway - Azure Application Gateway

# Application Gateway
resource "azurerm_application_gateway" "this" {
  name                = var.application_gateway.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.application_gateway.sku_name
    tier     = var.application_gateway.sku_tier
    capacity = var.application_gateway.capacity
  }

  # Configuration des IPs frontend
  dynamic "frontend_ip_configuration" {
    for_each = var.application_gateway.frontend_ip_configurations
    content {
      name                 = frontend_ip_configuration.key
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_name != null ? var.public_ip_ids[frontend_ip_configuration.value.public_ip_address_name] : null
      private_ip_address   = frontend_ip_configuration.value.private_ip_address
      subnet_id            = frontend_ip_configuration.value.subnet_id != null ? var.subnet_ids[frontend_ip_configuration.value.subnet_id] : var.subnet_ids[var.application_gateway.subnet_name]
    }
  }

  # Configuration des ports frontend
  dynamic "frontend_port" {
    for_each = var.application_gateway.frontend_ports
    content {
      name = frontend_port.key
      port = frontend_port.value
    }
  }

  # Configuration des pools backend
  dynamic "backend_address_pool" {
    for_each = var.application_gateway.backend_address_pools
    content {
      name         = backend_address_pool.key
      fqdns        = backend_address_pool.value
    }
  }

  # Configuration des paramètres HTTP backend
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

  # Configuration des listeners HTTP
  dynamic "http_listener" {
    for_each = var.application_gateway.http_listeners
    content {
      name                           = http_listener.key
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
    }
  }

  # Configuration des règles de routage
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
  }

  # Configuration IP du gateway (requis)
  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = var.subnet_ids[var.application_gateway.subnet_name]
  }

  tags = var.application_gateway.tags
} 