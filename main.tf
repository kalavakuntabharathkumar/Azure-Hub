resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = { project = "azure-hub-spoke", managed_by = "terraform" }
}

module "network" {
  source              = "./modules/network"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  hub_address_space   = var.hub_address_space
  spoke_address_space = var.spoke_address_space
}

module "compute" {
  source              = "./modules/compute"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.network.spoke_app_subnet_id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

module "load_balancer" {
  source              = "./modules/load-balancer"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  nic_ids             = module.compute.nic_ids
}

module "vpn" {
  source              = "./modules/vpn"
  count               = var.enable_vpn_gateway ? 1 : 0
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  hub_gateway_subnet_id = module.network.hub_gateway_subnet_id
  hub_vnet_id         = module.network.hub_vnet_id
  spoke_vnet_id       = module.network.spoke_vnet_id
}
