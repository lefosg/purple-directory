variable "location" {
    type = string
    description = "Location of resources"
}

variable "rg-name" {
    type = string
    description = "Name of the resource group"
}

variable "vnet-name" {
    type = string
    description = "Name of the virtual network"
}

variable "dc-subnet-name" {
    type = string
    description = "Name of the domain controllers subnet"
}

variable "siem-subnet-name" {
    type = string
    description = "Name of the siem subnet"
}

variable "workstations-subnet-name" {
    type = string
    description = "Name of the workstations subnet"
}

variable "gateway-subnet-name" {
    type = string
    description = "Name of the gateway subnet (VPN)"
}

variable "workstation-linux-vm-name" {
    type = string
    description = "Name of the linux workstation"
}

variable "workstation-windows-vm-name" {
    type = string
    description = "Name of the windows workstation"
}

variable "siem-wazuh-server-vm-name" {
    type = string
    description = "Name of the wazuh server SIEM"
}

variable "domain-controller-vm" {
    type = string
    description = "Name of the domain controller vm"
}
