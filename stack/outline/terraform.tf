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
      version = "0.94.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
  }
}
