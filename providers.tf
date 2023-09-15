terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.37.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.42.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}

provider "random" {
  # Configuration options
}