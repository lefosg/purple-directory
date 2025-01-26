output "vpngw-ip" {
    value = azurerm_public_ip.PIP-vnet-gateway
    description = "Public IP of the vnet gateway"
}

//these ips are the private ips
output "domain-controller-ip" {
    value = "${azurerm_network_interface.NIC-domain-controller-vm.*.private_ip_address}"
    description = "Domain Controller VM private ip address"
}

output "wazuh-server-ip" {
    value = "${azurerm_network_interface.NIC-wazuh-server-vm.*.private_ip_address}"
    description = "Wazuh Server VM private ip address"
}

output "linux-workstation-vm01-ip" {
    value = "${azurerm_network_interface.NIC-linux-workstation-vm01.*.private_ip_address}"
    description = "Linux Workstation VM private ip address"
}

output "workstation-windows-vm02-ip" {
    value = "${azurerm_network_interface.NIC-workstation-windows-vm.*.private_ip_address}"
    description = "Windows Workstation VM private ip address"
}