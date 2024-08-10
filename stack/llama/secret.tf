resource "vault_kubernetes_auth_backend_role" "self" {
  backend                          = "kubernetes"
  role_name                        = "llama"
  bound_service_account_names      = ["llama-vault"]
  bound_service_account_namespaces = ["llama"]
  token_ttl                        = 3600
  token_policies                   = [ vault_policy.self.name ]
  audience                         = "llama"
}

data "vault_policy_document" "self" {
  rule {
    path         = vault_kv_secret_v2.self.path
    capabilities = ["read", "list"]
    description  = "LLama read secrets"
  }
}

resource "vault_policy" "self" {
  name   = "llama_policy"
  policy = data.vault_policy_document.self.hcl
}

resource "vault_kv_secret_v2" "self" {
  mount                      = "applications"
  name                       = "llama"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    "PUBLIC_SSO_SERVER" = var.sso_domain
    "PUBLIC_CLIENT_ID" = var.sso_client_id
    "PUBLIC_SSO_REALM" = var.sso_realm
    "GROQ_API_KEY" = var.groq_api_key
  }
  )
}
PUBLIC_SSO_ACCOUNT_SETTINGS_URL=PUBLIC_SSO_SERVERrealms/PUBLIC_SSO_REALM/account
