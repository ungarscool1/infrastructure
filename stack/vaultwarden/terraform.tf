terraform {
  cloud {
    organization = "legodard"

    workspaces {
      name = "vaultwarden"
    }
  }

  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.92.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    vault = {
      source = "hashicorp/vault"
      version = "4.3.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "hcp" {
  project_id = data.terraform_remote_state.vault.outputs.project_id
}

provider "vault" {
  address = "https://vault.apps.legodard.fr"
  token = data.hcp_vault_secrets_secret.vault_token.secret_value
}
