stack {
  name        = "Random"
  description = "for a random string"
  id          = "f0f6fbaf-d82b-4a24-8dca-1fd40be549c2"
  tags        = ["dev"]
}

globals "terraform" "providers" "random" {
  enabled = true
  source  = "hashicorp/random"
  version = "3.4.3"
}

output "random_name" {
  backend   = "terraform"
  value     = module.random.random_name
  sensitive = false
}