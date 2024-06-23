terraform {
  cloud {
    organization = "legodard"

    workspaces {
      name = "vault"
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
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "hcp" {}
