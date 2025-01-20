module "file" {
  source    = "../../../modules/file"
  file_path = "${path.module}/${var.file_name}.txt"
}
