resource "random_password" "vaultwarden_db_password" {
  length           = 32
  special          = false
}

resource "hcp_vault_secrets_app" "vaultwarden" {
  app_name    = "vaultwarden"
  project_id = data.terraform_remote_state.vault.outputs.project_id
  description = "Vaultwarden application secrets"
}

resource "hcp_vault_secrets_secret" "db_password" {
  app_name     = "vaultwarden"
  project_id = data.terraform_remote_state.vault.outputs.project_id
  secret_name  = "POSTGRES_PASSWORD"
  secret_value = random_password.vaultwarden_db_password.result
}
