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
      version = "2.1.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.97.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.33.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "hcp" {}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}
