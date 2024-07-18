resource "hcp_vault_secrets_app" "self" {
  app_name    = "outline"
  description = ""
  project_id = data.terraform_remote_state.vault_outputs.outputs.project_id
}

resource "hcp_vault_secrets_secret" "sso_domain" {
  app_name     = hcp_vault_secrets_app.self.app_name
  project_id   = data.terraform_remote_state.vault_outputs.outputs.project_id
  secret_name  = "SSO_DOMAIN"
  secret_value = var.sso_domain
}

resource "hcp_vault_secrets_secret" "sso_client_id" {
  app_name     = hcp_vault_secrets_app.self.app_name
  project_id   = data.terraform_remote_state.vault_outputs.outputs.project_id
  secret_name  = "OIDC_CLIENT_ID"
  secret_value = var.sso_client_id
}

resource "hcp_vault_secrets_secret" "sso_client_secret" {
  app_name     = hcp_vault_secrets_app.self.app_name
  project_id   = data.terraform_remote_state.vault_outputs.outputs.project_id
  secret_name  = "OIDC_CLIENT_SECRET"
  secret_value = var.sso_client_secret
}

resource "hcp_vault_secrets_secret" "s3_ak" {
  app_name     = hcp_vault_secrets_app.self.app_name
  project_id   = data.terraform_remote_state.vault_outputs.outputs.project_id
  secret_name  = "AWS_ACCESS_KEY_ID"
  secret_value = var.aws_s3_access_key
}

resource "hcp_vault_secrets_secret" "s3_sk" {
  app_name     = hcp_vault_secrets_app.self.app_name
  project_id   = data.terraform_remote_state.vault_outputs.outputs.project_id
  secret_name  = "AWS_SECRET_ACCESS_KEY"
  secret_value = var.aws_s3_secret_key
}

resource "hcp_vault_secrets_secret" "s3_endpoint" {
  app_name     = hcp_vault_secrets_app.self.app_name
  project_id   = data.terraform_remote_state.vault_outputs.outputs.project_id
  secret_name  = "AWS_S3_UPLOAD_BUCKET_URL"
  secret_value = var.aws_s3_endpoint
}

resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$&()-_=+[]{}<>:"
}

resource "hcp_vault_secrets_secret" "db_password" {
  app_name     = hcp_vault_secrets_app.self.app_name
  project_id   = data.terraform_remote_state.vault_outputs.outputs.project_id
  secret_name  = "POSTGRES_PASSWORD"
  secret_value = random_password.db_password.result
}

resource "random_string" "db_username" {
  length           = 12
  special          = false
}

resource "hcp_vault_secrets_secret" "db_username" {
  app_name     = hcp_vault_secrets_app.self.app_name
  project_id   = data.terraform_remote_state.vault_outputs.outputs.project_id
  secret_name  = "POSTGRES_USERNAME"
  secret_value = random_string.db_username.result
}
