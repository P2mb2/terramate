// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}
locals {
  create_oidc_github = length(data.aws_iam_openid_connect_provider.github.arn) == 0
}
module "oidc_github" {
  attach_admin_policy = true
  count               = local.create_oidc_github ? 1 : 0
  github_repositories = [
    "P2mb2/terramate:*",
  ]
  source  = "unfunco/oidc-github/aws"
  version = "1.7.1"
}
