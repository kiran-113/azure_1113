resource "azurerm_virtual_network" "main" {
  count               = length(var.resource_group_name)
  name                = "${var.prefix}-network-${element(var.resource_group_name, count.index)}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azure_my_rg[count.index].location
  resource_group_name = azurerm_resource_group.azure_my_rg[count.index].name
}

resource "azurerm_subnet" "internal" {
  count                = length(var.resource_group_name)
  name                 = "internal-${element(var.resource_group_name, count.index)}"
  resource_group_name  = azurerm_resource_group.azure_my_rg[count.index].name
  virtual_network_name = azurerm_virtual_network.main[count.index].name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  count               = length(var.resource_group_name)
  name                = "${var.prefix}-nic-${element(var.resource_group_name, count.index)}"
  location            = azurerm_resource_group.azure_my_rg[count.index].location
  resource_group_name = azurerm_resource_group.azure_my_rg[count.index].name

  ip_configuration {
    name                          = "ip-${element(var.resource_group_name, count.index)}"
    subnet_id                     = azurerm_subnet.internal[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_virtual_machine" "main" {
  count                            = length(var.resource_group_name)
  name                             = "${var.prefix}-vm-${element(var.resource_group_name, count.index)}"
  location                         = azurerm_resource_group.azure_my_rg[count.index].location
  resource_group_name              = azurerm_resource_group.azure_my_rg[count.index].name
  network_interface_ids            = [azurerm_network_interface.main[count.index].id]
  vm_size                          = "Standard_B1s"
  delete_data_disks_on_termination = true

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1-${element(var.resource_group_name, count.index)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"


  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging-${element(var.resource_group_name, count.index)}"
  }
}
