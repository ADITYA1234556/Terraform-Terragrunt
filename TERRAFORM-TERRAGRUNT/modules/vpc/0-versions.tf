terraform {
  required_version = ">=1.0"

  // Version contrainsts for aws provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62"
    }
  }
}