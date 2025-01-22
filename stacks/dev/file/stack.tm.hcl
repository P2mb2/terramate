stack {
  name        = "File"
  description = "File"
  id          = "1e5bf4ca-5cf8-4d86-847c-453dbc4a23b3"
  tags        = ["dev"]

  after = ["../random"]
}

globals "terraform" "providers" "local" {
  enabled = true
  source  = "hashicorp/local"
  version = "2.5.2"
}

globals {
  random_stack_id = "f0f6fbaf-d82b-4a24-8dca-1fd40be549c2"
}

input "file_name" {
  backend       = "terraform"
  value         = outputs.random_name.value
  from_stack_id = global.random_stack_id
  mock          = "mocked-value"
}