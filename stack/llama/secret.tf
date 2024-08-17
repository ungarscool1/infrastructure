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
    path         = vault_kv_secret_v2.front.path
    capabilities = ["read", "list"]
    description  = "LLama front read secrets"
  }
  rule {
    path         = vault_kv_secret_v2.back.path
    capabilities = ["read", "list"]
    description  = "LLama back read secrets"
  }
}

resource "vault_policy" "self" {
  name   = "llama_policy"
  policy = data.vault_policy_document.self.hcl
}

resource "vault_kv_secret_v2" "front" {
  mount                      = "applications"
  name                       = "llama/front"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    "PUBLIC_SSO_SERVER" = var.sso_domain
    "PUBLIC_CLIENT_ID"  = var.sso_client_id
    "PUBLIC_SSO_REALM"  = var.sso_realm
  }
  )
}

resource "vault_kv_secret_v2" "back" {
  mount                      = "applications"
  name                       = "llama/back"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    "GROQ_API_KEY" = var.groq_api_key
    "jwt.pem"      = var.jwt_pem
  }
  )
}
