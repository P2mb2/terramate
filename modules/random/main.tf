resource "random_string" "name" {
  length           = var.length
  special          = var.special
  upper            = var.upper
  override_special = "/@£$"
}
