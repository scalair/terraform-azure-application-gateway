provider "vault" {
  address         = var.vault_endpoint
  skip_tls_verify = true
}

data "vault_generic_secret" "passwords" {
  path = var.pass_path_on_vault
}

data "vault_generic_secret" "identity" {
  path = var.path_certificate_data_on_vault
}
