data "terraform_remote_state" "vault" {
  backend = "remote"

  config = {
    organization = "legodard"
    workspaces = {
      name = "vault"
    }
  }
}

data "hcp_vault_secrets_secret" "vault_token" {
  app_name = "vault"
  secret_name = "root_token"
}
