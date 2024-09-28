resource "vault_kubernetes_auth_backend_role" "self" {
  backend                          = "kubernetes"
  role_name                        = "monitoring"
  bound_service_account_names      = ["monitoring"]
  bound_service_account_namespaces = ["monitoring"]
  token_ttl                        = 3600
  token_policies                   = [ vault_policy.self.name ]
  audience                         = "monitoring"
}

data "vault_policy_document" "self" {
  rule {
    path         = vault_kv_secret_v2.grafana.path
    capabilities = ["read", "list"]
    description  = "monitoring/grafana read secrets"
  }
}

resource "vault_policy" "self" {
  name   = "monitoring_policy"
  policy = data.vault_policy_document.self.hcl
}

resource "vault_kv_secret_v2" "grafana" {
  mount                      = "applications"
  name                       = "monitoring/grafana"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    GF_AUTH_GENERIC_OAUTH_ENABLED             = var.grafana_oauth.enabled
    GF_AUTH_GENERIC_OAUTH_NAME                = var.grafana_oauth.name
    GF_AUTH_GENERIC_OAUTH_ALLOW_SIGN_UP       = true
    GF_AUTH_GENERIC_OAUTH_CLIENT_ID           = var.grafana_oauth.client_id
    GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET       = var.grafana_oauth.client_secret
    GF_AUTH_GENERIC_OAUTH_SCOPES              = "openid profile email"
    GF_AUTH_GENERIC_OAUTH_AUTH_URL            = "${var.grafana_oauth.server}/protocol/openid-connect/auth"
    GF_AUTH_GENERIC_OAUTH_TOKEN_URL           = "${var.grafana_oauth.server}/protocol/openid-connect/token"
    GF_AUTH_GENERIC_OAUTH_API_URL             = "${var.grafana_oauth.server}/protocol/openid-connect/userinfo"
    GF_AUTH_GENERIC_OAUTH_ROLE_ATTRIBUTE_PATH = var.grafana_oauth.attributes
  }
  )
}
