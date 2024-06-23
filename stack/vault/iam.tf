resource "hcp_service_principal" "self" {
  name   = "kubernetes"
  parent = hcp_project.self.resource_name
}

resource "hcp_service_principal_key" "self" {
  service_principal = hcp_service_principal.self.resource_name
}

resource "hcp_project_iam_binding" "example" {
  project_id   = hcp_project.self.resource_id
  principal_id = hcp_service_principal.self.resource_id
  role         = "roles/viewer"
}
