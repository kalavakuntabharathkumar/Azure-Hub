output "resource_group_name" { value = azurerm_resource_group.this.name }
output "hub_vnet_id" { value = module.network.hub_vnet_id }
output "spoke_vnet_id" { value = module.network.spoke_vnet_id }
output "load_balancer_public_ip" { value = module.load_balancer.public_ip }
