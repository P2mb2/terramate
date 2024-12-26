globals "terraform" {
  version = "1.10.2"
  company = "vdfiot"
  project = "template"
  repo = "terramate"
}

globals "terraform" "environment" {
  name = "default"
}

globals "terraform" "backend" {
  bucket = "${global.terraform.company}-${global.terraform.project}-${global.terraform.environment.name}-backend"
  region = "eu-central-1"
}

globals "aws" "oidc" {
  github_repositories = [
    "P2mb2/${global.terraform.repo}:*",
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

