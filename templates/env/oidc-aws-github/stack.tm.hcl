stack {
  name        = "oidc-aws-github"
  description = "oidc-aws-github"
  id          = "c9931ff8-c181-425f-9717-20142b57fd1b"
  tags        = ["no-backend", "cicd-ignore", "bootstrap"]
  after       = ["../terraform-state-bucket"]
}
