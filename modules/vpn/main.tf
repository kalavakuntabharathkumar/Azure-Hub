# Gateway and connection are intentionally optional: gateway SKUs have ongoing cost.
resource "azurerm_public_ip" "gateway" {
  name                = "${var.prefix}-vpn-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_virtual_network_gateway" "hub" {
  name                = "${var.prefix}-hub-vpngw"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  active_active       = false
  enable_bgp          = false
  ip_configuration {
    name                          = "gateway-ip"
    public_ip_address_id          = azurerm_public_ip.gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.hub_gateway_subnet_id
  }
}
