variable "aksPublic" {
  description = "Objet contenant toutes les configurations AKS"
  type = object({
    cluster_name        = string
    location            = string
    dns_prefix          = string
    subnet_name         = string
  })
}

variable "resource_group_name" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
  description = "Map of subnet names to subnet IDs"
}