variable "subnet_ids" {
  type = map(string)
  description = "Map of subnet names to subnet IDs"
}


variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
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

