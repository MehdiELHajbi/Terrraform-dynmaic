variable "subnet_ids" {
  type = map(string)
  description = "Map of subnet names to subnet IDs"
}
variable "firewallIpPrivates" {
  type = map(string)
  description = "Map of firewall names to firewall Ips"
}

variable "dns_zone_ids" {
  type = map(string)
  description = "Map of firewall names to firewall Ips"
  default     = {}  # Par défaut, une map vide
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
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


variable "route" {
  description = "Objet contenant route table aks firwall"
  type = object({
    name                   = string
    address_prefix         = string  # destionation internet
    next_hop_in_ip_address = string   # il doit passer passer par le firewall (ip privé ) pour sortir a internet
  })
}