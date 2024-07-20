resource "vault_kv_secret_v2" "self" {
  mount                      = "applications"
  name                       = "outline"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    AWS_ACCESS_KEY_ID        = var.aws_s3_access_key,
    AWS_SECRET_ACCESS_KEY    = var.aws_s3_secret_key,
    AWS_S3_UPLOAD_BUCKET_URL = var.aws_s3_endpoint,
    OIDC_CLIENT_ID           = var.sso_client_id,
    OIDC_CLIENT_SECRET       = var.sso_client_secret,
    OIDC_DOMAIN              = var.sso_domain,
    POSTGRES_USERNAME        = random_string.db_username.result,
    POSTGRES_PASSWORD        = random_password.db_password.result,
    SECRET_KEY               = random_bytes.secret_key.hex,
    UTILS_SECRET             = random_bytes.utils_secret.hex
  }
  )
}

resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$&()-_=+[]{}<>:"
}

resource "random_string" "db_username" {
  length           = 12
  special          = false
}

resource "random_bytes" "secret_key" {
  length = 32
}

resource "random_bytes" "utils_secret" {
  length = 32
}
