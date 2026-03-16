# ১. প্রোভাইডার কনফিগারেশন
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # টেস্টিংয়ের জন্য আমরা লোকাল স্টেট ব্যবহার করছি কারণ আপনার Azure Storage নেই
  backend "local" {}
}

provider "azurerm" {
  features {}
  # এক্সেস না থাকলে এই ভ্যালুগুলো ডামি হিসেবে থাকবে
  skip_provider_registration = true
}

# ২. ভেরিয়েবল (ডাইনামিক নাম দেওয়ার জন্য)
variable "env_suffix" {
  default = "testing"
}

# ৩. রিসোর্স গ্রুপ (এটি একটি কন্টেইনারের মতো কাজ করে)
resource "azurerm_resource_group" "test_rg" {
  name     = "rg-test-${var.env_suffix}"
  location = "East US"
}

# ৪. Key Vault রিসোর্স (সরাসরি কোড অথবা মডিউল হিসেবে)
resource "azurerm_key_vault" "test_kv" {
  name                        = "kv-test-${var.env_suffix}"
  location                    = azurerm_resource_group.test_rg.location
  resource_group_name         = azurerm_resource_group.test_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = "00000000-0000-0000-0000-000000000000" # ডামি আইডি
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = "00000000-0000-0000-0000-000000000000"
    object_id = "00000000-0000-0000-0000-000000000000"

    key_permissions = ["Get",]
    secret_permissions = ["Get",]
    storage_permissions = ["Get",]
  }
}
