terraform {
  required_version = ">= 1.8.0"

  required_providers {
    azurerm = {
      version = ">= 4.7.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = ">=1.1"
    }
  }
}
