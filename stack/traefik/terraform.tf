terraform {
  cloud {
    organization = "legodard"

    workspaces {
      name = "traefik"
    }
  }

  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}
