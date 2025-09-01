variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure location for the Container Apps"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics workspace for Container Apps"
}

variable "environment_name" {
  type        = string
  description = "Name of the Container Apps environment"
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of subnet names to subnet IDs"
}

variable "container_apps" {
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
  description = "Configuration for Container Apps"
} 