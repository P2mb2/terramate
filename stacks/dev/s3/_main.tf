// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "aws_s3_bucket" "state-bucket" {
  bucket = "vdfiot-template-dev-mys3"
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}
