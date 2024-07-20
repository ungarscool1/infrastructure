resource "random_password" "vaultwarden_db_password" {
  length           = 32
  special          = false
}

resource "vault_kubernetes_auth_backend_role" "self" {
  backend                          = "kubernetes"
  role_name                        = "vaultwarden"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["vaultwarden"]
  token_ttl                        = 3600
  token_policies                   = [ vault_policy.self.name ]
  audience                         = "vaultwarden"
}

data "vault_policy_document" "self" {
  rule {
    path         = vault_kv_secret_v2.self.path
    capabilities = ["read", "list"]
    description  = "Vaultwarden read secrets"
  }
}

resource "vault_policy" "self" {
  name   = "vaultwarden_policy"
  policy = data.vault_policy_document.self.hcl
}

resource "vault_kv_secret_v2" "self" {
  mount                      = "applications"
  name                       = "vaultwarden"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    POSTGRES_PASSWORD        = random_password.vaultwarden_db_password.result,
    PUSH_INSTALLATION_KEY    = var.push_installation_key,
    PUSH_INSTALLATION_ID     = var.push_installation_id
  }
  )
}