provider "aws" {
  region = "eu-west-2"
}

// Version 1 or higher,
terraform {
  required_version = ">=1.0"

  backend "local" {
    path = "test/backend/terraform.tfstate"
  }

  // Version contrainsts for aws provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62"
    }
  }
}