terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "local" {}
}

provider "azurerm" {
  features {}
  # নিচের এই ৩টি লাইন অবশ্যই যোগ করুন
  skip_provider_registration = true
  subscription_id            = "00000000-0000-0000-0000-000000000000"
  tenant_id                  = "00000000-0000-0000-0000-000000000000"
}
}

resource "azurerm_resource_group" "test_rg" {
  name     = "rg-dummy-qa"
  location = "East US"
}

resource "azurerm_key_vault" "test_kv" {
  name                        = "kv-dummy-unit-test-01"
  location                    = azurerm_resource_group.test_rg.location
  resource_group_name         = azurerm_resource_group.test_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
  soft_delete_retention_days  = 7
  sku_name                    = "standard"

  access_policy {
    tenant_id          = "00000000-0000-0000-0000-000000000000"
    object_id          = "00000000-0000-0000-0000-000000000000"
    secret_permissions = ["Get", "List", "Set"]
  }
}
