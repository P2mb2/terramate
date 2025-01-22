resource "local_file" "my_file" {
  content  = "my file generated with terraform!!!"
  filename = var.file_path
}
