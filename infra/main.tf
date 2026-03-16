# ১. প্রোভাইডার কনফিগারেশন (Terraform Settings)
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # টেস্টিংয়ের জন্য লোকাল ব্যাকএন্ড ব্যবহার করা হয়েছে
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  # এক্সেস ছাড়া টেস্টিংয়ের জন্য এই অপশনটি জরুরি
  skip_provider_registration = true
}

# ২. ভেরিয়েবল (Variables)
variable "resource_group_name" {
  type    = string
  default = "rg-dummy-testing"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "kv_name" {
  type    = string
  default = "kv-dummy-logic-test"
}

# ৩. রিসোর্স গ্রুপ (Resource Group)
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# ৪. ডামি কি-ভল্ট (Key Vault Resource)
resource "azurerm_key_vault" "example" {
  name                        = var.kv_name
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = "00000000-0000-0000-0000-000000000000" # Dummy Tenant ID
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  # এক্সেস পলিসি (Access Policy)
  access_policy {
    tenant_id = "00000000-0000-0000-0000-000000000000" # Dummy ID
    object_id = "00000000-0000-0000-0000-000000000000" # Dummy ID

    key_permissions = [
      "Get", "List", "Create", "Delete",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete",
    ]
  }

  tags = {
    environment = "testing"
    purpose     = "github-action-validation"
  }
}

# ৫. আউটপুট (Outputs)
output "key_vault_id" {
  value       = azurerm_key_vault.example.id
  description = "The ID of the Key Vault"
}
