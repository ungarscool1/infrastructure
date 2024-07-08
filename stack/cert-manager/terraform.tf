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
      version = "2.0.4"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}