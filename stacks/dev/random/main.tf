module "random" {
  source  = "../../../modules/random"
  length  = var.length
  special = var.special
  upper   = var.upper
}
