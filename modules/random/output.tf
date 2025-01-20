output "random_name" {
  value     = resource.random_string.name.result
  sensitive = false
}
