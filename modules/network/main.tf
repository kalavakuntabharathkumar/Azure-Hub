resource "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-hub-vnet"
  address_space       = var.hub_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_virtual_network" "spoke" {
  name                = "${var.prefix}-spoke-vnet"
  address_space       = var.spoke_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "hub_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.10.0.0/27"]
}
resource "azurerm_subnet" "hub_shared" {
  name                 = "snet-hub-shared"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.10.1.0/24"]
}
resource "azurerm_subnet" "spoke_app" {
  name                 = "snet-spoke-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.20.1.0/24"]
}
resource "azurerm_subnet" "spoke_data" {
  name                 = "snet-spoke-data"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.20.2.0/24"]
}
resource "azurerm_network_security_group" "hub" {
  name                = "${var.prefix}-hub-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}
resource "azurerm_network_security_group" "spoke" {
  name                = "${var.prefix}-spoke-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "AllowHttpFromInternet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}
resource "azurerm_subnet_network_security_group_association" "spoke_app" {
  subnet_id                 = azurerm_subnet.spoke_app.id
  network_security_group_id = azurerm_network_security_group.spoke.id
}
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = false
}
resource "azurerm_route_table" "spoke" {
  name                = "${var.prefix}-spoke-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
  route {
    name                   = "to-hub-private-range"
    address_prefix         = "10.10.0.0/16"
    next_hop_type          = "VnetLocal"
  }
}
resource "azurerm_subnet_route_table_association" "spoke_app" {
  subnet_id      = azurerm_subnet.spoke_app.id
  route_table_id = azurerm_route_table.spoke.id
}

resource "azurerm_network_watcher" "this" {
  name                = "${var.prefix}-network-watcher"
  location            = var.location
  resource_group_name = var.resource_group_name
}
