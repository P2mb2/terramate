generate_hcl "_main.tf" {
  content {
    resource "aws_kms_key" "state-bucket-key" {
      description             = "This key is used to encrypt bucket objects"
      deletion_window_in_days = 10
    }

    resource "null_resource" "delete_objects" {
      provisioner "local-exec" {
        command = <<EOT
          aws s3api list-object-versions --bucket example-bucket --query "Versions[].{Key: Key, VersionId: VersionId}" --output json | \
          jq -r '.[] | "aws s3api delete-object --bucket example-bucket --key \(.Key) --version-id \(.VersionId)"' | bash
        EOT
      }
    }

    resource "aws_s3_bucket" "state-bucket" {
      bucket = global.terraform.backend.bucket
      force_destroy = true
      object_lock_enabled = true

      tags = {
        Name = "S3 Remote Terraform State Store"
      }
      depends_on = [null_resource.delete_objects]
    }

    resource "aws_s3_bucket_versioning" "state-bucket" {
      bucket = aws_s3_bucket.state-bucket.bucket

      versioning_configuration {
        status = "Enabled"
      }
    }

    resource "aws_s3_bucket_server_side_encryption_configuration" "state-bucket" {
      bucket = aws_s3_bucket.state-bucket.id

      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key.state-bucket-key.arn
          sse_algorithm     = "aws:kms"
        }
      }
    }

    resource "aws_dynamodb_table" "terraform-lock" {
      name           = tm_try(global.terraform.backend.dynamodb_table, "terraform-lock")
      read_capacity  = 5
      write_capacity = 5
      hash_key       = "LockID"
      attribute {
        name = "LockID"
        type = "S"
      }
      tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
      }
    }
  }
}
