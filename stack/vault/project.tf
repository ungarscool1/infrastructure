resource "hcp_project" "self" {
  name = "kubernetes-${terraform.workspace}"
}
