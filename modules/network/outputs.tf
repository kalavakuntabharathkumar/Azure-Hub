output "hub_vnet_id" { value = azurerm_virtual_network.hub.id }
output "spoke_vnet_id" { value = azurerm_virtual_network.spoke.id }
output "hub_gateway_subnet_id" { value = azurerm_subnet.hub_gateway.id }
output "spoke_app_subnet_id" { value = azurerm_subnet.spoke_app.id }
