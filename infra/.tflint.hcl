config {
  module = true
  force = false
}

# Azure এর জন্য লিন্টিং রুলস লোড করা
plugin "azurerm" {
    enabled = true
    version = "0.27.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# কিছু বেসিক রুলস অন করা
rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}
