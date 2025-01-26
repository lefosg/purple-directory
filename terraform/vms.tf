##################################################################
###### Linux VM Workstation - all-vnet/workstations-subnet03 #####
##################################################################

resource "azurerm_network_interface" "NIC-linux-workstation-vm01" {
  name                = "NIC-linux-workstation-vm01"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"  // singal to create resource group first

  ip_configuration {
    name                          = "NIC-linux-ip-vm01"
    subnet_id                     = "${azurerm_subnet.workstations-subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "workstation-linux-vm01" {
  name                  = var.workstation-linux-vm-name
  location              = var.location
  resource_group_name   = "${azurerm_resource_group.all-rg.name}"
  network_interface_ids = [azurerm_network_interface.NIC-linux-workstation-vm01.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "OSDISK-workstation-linux-vm01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.workstation-linux-vm-name
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

##################################################################
####### Windows Workstation - all-vnet/workstations-subnet03 #####
##################################################################

resource "azurerm_network_interface" "NIC-workstation-windows-vm" {
  name                = "NIC-windows-workstation-vm"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"

  ip_configuration {
    name                          = "NIC-windows-workstation-vm-ip"
    subnet_id                     = "${azurerm_subnet.workstations-subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

// Create Network Security Group and rules
resource "azurerm_network_security_group" "NSG-workstation-windows-vm" {
  name                = "NSG-workstation-windows-vm"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

//Associate NIC with NSG
resource "azurerm_network_interface_security_group_association" "WIN-WORK-NIC-NSG" {
  network_interface_id      = azurerm_network_interface.NIC-workstation-windows-vm.id
  network_security_group_id = azurerm_network_security_group.NSG-workstation-windows-vm.id
}

resource "azurerm_windows_virtual_machine" "workstation-windows-vm" {
  name                = var.workstation-windows-vm-name  // is the hostname as well
  resource_group_name = "${azurerm_resource_group.all-rg.name}"
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  computer_name       = var.workstation-windows-vm-name
  network_interface_ids = [
    azurerm_network_interface.NIC-workstation-windows-vm.id,
  ]

  os_disk {
    name                 = "OSDISK-workstation-windows-vm02"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-ent-ltsc"
    version   = "latest"
  }
}

##################################################################
######### Wazuh Server VM - all-vnet/siem-subnet02 ###############
##################################################################

resource "azurerm_network_interface" "NIC-wazuh-server-vm" {
  name                = "NIC-wazuh-server-vm"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"  // singal to create resource group first

  ip_configuration {
    name                          = "NIC-wazuh-server-vm-ip-vm"
    subnet_id                     = "${azurerm_subnet.siem-subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "wazuh-server-vm" {
  name                  = var.siem-wazuh-server-vm-name
  location              = var.location
  resource_group_name   = "${azurerm_resource_group.all-rg.name}"
  network_interface_ids = [azurerm_network_interface.NIC-wazuh-server-vm.id]
  vm_size               = "Standard_D2as_v4"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "OSDISK-wazuh-server-vm"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.siem-wazuh-server-vm-name
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine_extension" "VM-EXT-install-wazuh" {
  name                 = "VM-EXT-install-wazuh"
  virtual_machine_id   = azurerm_virtual_machine.wazuh-server-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "fileUris": ["install-wazuh-server.sh"],
        "commandToExecute": "bash install-wazuh-server.sh"
    }
SETTINGS
}

##################################################################
##### Domain Controller - all-vnet/domain-controller-subnet01 ####
##################################################################

resource "azurerm_network_interface" "NIC-domain-controller-vm" {
  name                = "NIC-domain-controller-vm"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"

  ip_configuration {
    name                          = "NIC-domain-controller-vm-ip"
    subnet_id                     = "${azurerm_subnet.domain-controllers-subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

// Create Network Security Group and rules
resource "azurerm_network_security_group" "NSG-ad-dc-vm" {
  name                = "NSG-ad-dc-vm"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

//Associate NIC with NSG
resource "azurerm_network_interface_security_group_association" "AD-DC-NIC-NSG" {
  network_interface_id      = azurerm_network_interface.NIC-domain-controller-vm.id
  network_security_group_id = azurerm_network_security_group.NSG-ad-dc-vm.id
}

resource "azurerm_windows_virtual_machine" "domain-controller-vm" {
  name                = var.domain-controller-vm  // is the hostname as well
  resource_group_name = "${azurerm_resource_group.all-rg.name}"
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.NIC-domain-controller-vm.id,
  ]

  os_disk {
    name                 = "OSDISK-domain-controller-vm"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}