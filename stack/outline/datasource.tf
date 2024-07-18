data "terraform_remote_state" "vault_outputs" {
  backend = "remote"
  config = {
    organization = "legodard"
    workspaces = {
      name = "vault"
    }
  }
}