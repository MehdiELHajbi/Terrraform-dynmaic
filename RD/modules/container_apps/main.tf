# Module Container Apps - Azure Container Apps

# Log Analytics workspace pour les logs des Container Apps
resource "azurerm_log_analytics_workspace" "container_apps" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = "Hub-Spoke"
    Module      = "ContainerApps"
  }
}

# Environment Container Apps
resource "azurerm_container_app_environment" "this" {
  name                       = var.environment_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.container_apps.id
  
  # Subnet d'infrastructure pour Container Apps
  infrastructure_subnet_id = var.subnet_ids[var.container_apps.subnet_name]

  tags = {
    Environment = "Hub-Spoke"
    Module      = "ContainerApps"
  }
}

# Container Apps
resource "azurerm_container_app" "this" {
  for_each = var.container_apps.apps

  name                         = each.key
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Multiple"

  template {
    container {
      name   = each.value.container_name
      image  = each.value.image
      cpu    = each.value.cpu
      memory = each.value.memory

      # Variables d'environnement dynamiques
      dynamic "env" {
        for_each = each.value.env_vars != null ? each.value.env_vars : {}
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    min_replicas = each.value.min_replicas
    max_replicas = each.value.max_replicas
  }

  ingress {
    external_enabled = each.value.external_ingress
    target_port      = each.value.target_port
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = {
    Environment = "Hub-Spoke"
    Module      = "ContainerApps"
    App         = each.key
  }
} 