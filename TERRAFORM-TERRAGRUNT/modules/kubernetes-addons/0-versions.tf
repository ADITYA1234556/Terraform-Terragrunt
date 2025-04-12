terraform {
  required_version = ">=1.0"

  // Version contrainsts for aws provider
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
  }
}

