terraform {
  cloud {
    organization = "legodard"

    workspaces {
      name = "cert-manager"
    }
  }

  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.1.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}