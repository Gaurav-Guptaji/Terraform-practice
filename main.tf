terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}
provider "azurerm" {
  features {}
  skip_provider_registration = true
}


# RESOURCE GROUP
module "rg" {
  source   = "./modules/resource_group"
  name     = "rg1"
  location = "central india"
}

# STORAGE ACCOUNT + BLOB CONTAINER
module "storage" {
  source              = "./modules/storage_account"
  name                = "demosa1234"
  location            = module.rg.location
  resource_group_name = module.rg.name
  container_name      = "demoblob1"
}


# NETWORK CONFIG
module "network" {
  source              = "./modules/network_config"
  location            = module.rg.location
  resource_group_name = module.rg.name
}

# WINDOWS VM PROVISIONING
module "windows_vm" {
  source              = "./modules/windows_vm"
  name                = "demo-win-vm"
  location            = module.rg.location
  resource_group_name = module.rg.name
  admin_username      = "admin1"
  admin_password      = "P@ssword1234!"
  nic_id              = module.network.nic_id
}