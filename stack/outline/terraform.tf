terraform {
  cloud {
    organization = "legodard"

    workspaces {
      name = "outline"
    }
  }

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.97.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
    vault = {
      source = "hashicorp/vault"
      version = "4.4.0"
    }
  }
}

provider "hcp" {
  project_id = data.terraform_remote_state.vault_outputs.outputs.project_id
}

provider "vault" {
  address = "https://vault.apps.legodard.fr"
  token = data.hcp_vault_secrets_secret.vault_token.secret_value
}
