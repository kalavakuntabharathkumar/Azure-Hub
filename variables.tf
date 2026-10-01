variable "location" { type = string; default = "centralindia" }
variable "prefix" { type = string; default = "azhubdemo" }
variable "admin_username" { type = string; default = "azureuser" }
variable "ssh_public_key" {
  type        = string
  description = "Contents of an SSH public key; never provide a private key."
}
variable "enable_vpn_gateway" {
  type        = bool
  default     = false
  description = "VPN gateways are costly and take longer to provision."
}
variable "hub_address_space" { type = list(string); default = ["10.10.0.0/16"] }
variable "spoke_address_space" { type = list(string); default = ["10.20.0.0/16"] }
