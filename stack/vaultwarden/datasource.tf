data "terraform_remote_state" "vault" {
  backend = "remote"

  config = {
    organization = "legodard"
    workspaces = {
      name = "vault"
    }
  }
}