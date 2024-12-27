generate_hcl "_main.tf" {
  content {
    resource "aws_s3_bucket" "state-bucket" {
      bucket = "${global.project.company}-${global.project.name}-${global.terraform.environment.name}-mys3"
      tags = {
        Name = "S3 Remote Terraform State Store"
      }
    }
  }
}
