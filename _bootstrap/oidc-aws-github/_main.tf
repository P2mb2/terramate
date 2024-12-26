// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "oidc_github" {
  attach_admin_policy = true
  github_repositories = [
    "P2mb2/terramate:ref:refs/heads/main",
  ]
  source  = "unfunco/oidc-github/aws"
  version = "1.7.1"
}
