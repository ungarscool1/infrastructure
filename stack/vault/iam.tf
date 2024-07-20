resource "hcp_service_principal" "self" {
  name   = "kubernetes"
  parent = hcp_project.self.resource_name
}

resource "hcp_service_principal_key" "self" {
  service_principal = hcp_service_principal.self.resource_name
}

resource "hcp_project_iam_binding" "self" {
  project_id   = hcp_project.self.resource_id
  principal_id = hcp_service_principal.self.resource_id
  role         = "roles/viewer"
}

resource "hcp_service_principal" "vault" {
  name   = "kubernetes-vault"
  parent = hcp_project.self.resource_name
}

resource "hcp_service_principal_key" "vault" {
  service_principal = hcp_service_principal.vault.resource_name
}

locals {
  hcp_vault_roles = [
    "roles/contributor",
    "roles/secrets.app-manager",
  ]
}

resource "hcp_project_iam_binding" "vault" {
  for_each     = toset(local.hcp_vault_roles)
  project_id   = hcp_project.self.resource_id
  principal_id = hcp_service_principal.vault.resource_id
  role         = each.value
}
