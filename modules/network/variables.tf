variable "prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "hub_address_space" { type = list(string) }
variable "spoke_address_space" { type = list(string) }
