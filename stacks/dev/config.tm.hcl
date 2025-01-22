sharing_backend "terraform" {
  type     = terraform
  command  = ["terraform", "output", "-json"]
  filename = "_sharing.tf"
}
