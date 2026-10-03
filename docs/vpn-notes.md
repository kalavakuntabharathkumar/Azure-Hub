# VNet-to-VNet VPN implementation notes

The hub gateway is optional because VPN Gateway SKUs have material hourly charges. For a complete two-gateway VNet-to-VNet lab, create a gateway in each VNet, then create one `azurerm_virtual_network_gateway_connection` per side using `connection_type = "Vnet2Vnet"` and the peer gateway ID. Store the shared key in a secret store and pass it through a sensitive variable. Validate BGP, address prefixes, and gateway SKU compatibility before deployment.
