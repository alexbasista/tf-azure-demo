variable "resource_group_name" {
  type        = string
  description = "Name of Azure Resource Group to create."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for taggable Azure resources."
  default     = {}
}

variable "vm_subnet_id" {
  type        = string
  description = "Subnet ID to provision VM Network Interface on."
}

variable "vm_username" {
  type        = string
  description = "Username for local administrator account of Virtual Machine."
  default     = "demo"
}

variable "vm_password" {
  type        = string
  description = "Password for local administrator account of Virtual Machine."
  sensitive   = true
}