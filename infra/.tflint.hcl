config {
  # পুরনো 'module = true' এর বদলে নিচের লাইনটি লিখুন
  call_module_type = "all" 
  force            = false
}

plugin "azurerm" {
    enabled = true
    version = "0.27.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
