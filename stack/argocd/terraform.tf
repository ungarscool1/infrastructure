terraform {
  cloud {
    organization = "legodard"

    workspaces {
      name = "argocd"
    }
  }
  required_providers {
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