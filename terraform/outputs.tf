output "vpngw-ip" {
    value = azurerm_public_ip.PIP-vnet-gateway
    description = "Public IP of the vnet gateway"
}

output "wazuh-server-ip" {
    value = "${azurerm_network_interface.NIC-wazuh-server-vm.*.private_ip_address}"
    description = "Wazuh Server VM private ip address"
}
