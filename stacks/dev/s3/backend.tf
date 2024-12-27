// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  backend "s3" {
    bucket         = "vdfiot-template-dev-backend"
    dynamodb_table = "terraform-lock"
    encrypt        = true
    key            = "terraform/stacks/by-id/13c36357-22b9-4b8e-b99c-146f97f2420f/terraform.tfstate"
    region         = "eu-central-1"
  }
}
