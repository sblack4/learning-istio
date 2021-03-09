
###############################################
# Provider/Backend/Workspace Check
###############################################

provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}

terraform {
  required_version = ">= 0.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.36.0"
    }
  }
}
