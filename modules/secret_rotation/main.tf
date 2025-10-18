resource "random_password" "rotated" {
  length           = 16
  special          = true
  override_special = "!@#%^&*()-_=+"

}

resource "azurerm_key_vault_secret" "rotated_secret" {
  name         = var.secret_name
  value        = random_password.rotated.result
  key_vault_id = var.key_vault_id
}
