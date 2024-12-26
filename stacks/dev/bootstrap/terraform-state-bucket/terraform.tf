// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  required_version = "1.10.2"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = "eu-central-1"
}
