globals "terraform" {
  version = "1.8.5"
}

globals "terraform" "backend" {
  bucket = "vdfiot-iot-template-terraform-state-backend"
  region = "eu-central-1"
}

globals "aws" "oidc" {
  github_repositories = [
    "terramate-io/terramate-quickstart-aws",
    # "another-org/another-repo:ref:refs/heads/main",
  ]
}

globals "terraform" "providers" "aws" {
  enabled = true
  source  = "hashicorp/aws"
  version = "~> 5.48"
  config = {
    region = "eu-central-1"
  }
}
