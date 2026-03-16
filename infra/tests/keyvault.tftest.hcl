# এই টেস্টটি চেক করবে যে Key Vault-এর কনফিগারেশন আমাদের শর্ত অনুযায়ী আছে কি না
run "verify_keyvault_logic" {
  command = plan # আসল রিসোর্স তৈরি না করে শুধু প্ল্যান চেক করবে

  # টেস্ট ১: নাম কি 'kv-' দিয়ে শুরু হয়েছে?
  assert {
    condition     = can(regex("^kv-", azurerm_key_vault.test_kv.name))
    error_message = "ভুল: Key Vault-এর নাম অবশ্যই 'kv-' দিয়ে শুরু হতে হবে।"
  }

  # টেস্ট ২: সঠিক SKU ব্যবহার করা হয়েছে কি না?
  assert {
    condition     = azurerm_key_vault.test_kv.sku_name == "standard"
    error_message = "ভুল: SKU অবশ্যই standard হতে হবে।"
  }
}
