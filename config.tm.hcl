globals "project" {
  name    = "template"
  company = "vdfiot"
  repo    = "terramate"
}

globals "project" "environment" "dev" {
  name = "dev"
}

globals "terraform" {
  version = "1.10.2"
}

globals "terraform" "backend" {
  bucket         = "${global.project.company}-${global.project.name}-${global.terraform.environment.name}-backend"
  dynamodb_table = "${global.project.company}-${global.project.name}-${global.terraform.environment.name}-dynamodb"
  region         = "eu-central-1"
}

globals "aws" "oidc" {
  github_repositories = [
    "P2mb2/${global.project.repo}:*",
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
