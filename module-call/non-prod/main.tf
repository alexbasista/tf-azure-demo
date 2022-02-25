terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.97.0"
    }
  }
}

provider "azurerm" {
  environment = "public"
  features {}
}

module "vnet" {
  source  = "app.terraform.io/terraform-tom/demo-module/azurerm"
  version = "0.1.0"

  resource_group_name = "abasista-tfe-pmr-test"
  location            = "East US 2"
  common_tags         = {
      "env"       = "test"
      "terraform" = "cloud"
      "owner"     = "abasista"
  }

  vnet_name      = "alex-vnet-from-module"
  vnet_cidr      = ["10.0.0.0/16"]
  vm_subnet_cidr = "10.0.1.0/24"
}