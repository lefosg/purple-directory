resource "azurerm_public_ip" "PIP-vnet-gateway" {
  name                = "vnet-gateway-pip"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"
  sku                 = "Standard"
  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "vnetgw" {
  name                = "vnetgw"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.all-rg.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.PIP-vnet-gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.gateway-subnet.id}"
  }

  vpn_client_configuration {
    address_space = ["172.0.10.0/24"]

    vpn_auth_types = [ "AAD" ]
    vpn_client_protocols = [ "OpenVPN" ]

    aad_tenant = "https://login.microsoftonline.com/ad5ba4a2-7857-4ea1-895e-b3d5207a174f"
    aad_audience = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
    aad_issuer = "https://sts.windows.net/ad5ba4a2-7857-4ea1-895e-b3d5207a174f/"
  }
}