resource "azurerm_network_interface" "this" {
  for_each            = var.vms
  name                = "${each.value.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = each.value.nic_ip_configuration_name
    subnet_id                     = var.subnet_ids[each.value.subnet_name]
    private_ip_address_allocation = each.value.private_ip_address_allocation
  }
}

# Le reste du code reste inchangé

resource "azurerm_linux_virtual_machine" "this" {
  for_each              = var.vms
  name                  = each.value.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = each.value.vm_size
  admin_username        = each.value.admin_username
  network_interface_ids = [azurerm_network_interface.this[each.key].id]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = file(each.value.ssh_public_key)
  }

  os_disk {
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = each.value.image_version
  }
}