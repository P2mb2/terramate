generate_hcl "_main.tf" {
  content {
    data "aws_iam_openid_connect_provider" "github" {
      url = "https://token.actions.githubusercontent.com"
    }

    # Local variable to determine if the module should be created
    locals {
      create_oidc_github = length(data.aws_iam_openid_connect_provider.github.arn) == 0
    }

    module "oidc_github" {
      count = local.create_oidc_github ? 1 : 0
      
      source  = "unfunco/oidc-github/aws"
      version = "1.7.1"

      github_repositories = global.aws.oidc.github_repositories
      attach_admin_policy = true
    }
  }
}
