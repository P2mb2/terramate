// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  backend "s3" {
    bucket         = "vdfiot-template-dev-backend"
    dynamodb_table = "terraform-lock"
    encrypt        = true
    key            = "terraform/stacks/by-id/3975980b-9e4a-45d0-b397-e6822a831820/terraform.tfstate"
    region         = "eu-central-1"
  }
}
