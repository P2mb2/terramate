generate_hcl "_backend.tf" {
  content {
    # terraform {
    #   backend "s3" {
    #     bucket         = global.backend.bucket
    #     dynamodb_table = global.backend.dynamodb_table
    #     region         = global.backend.region
    #     key            = "${global.backend.key}/stacks/${terramate.stack.id}/terraform.tfstate"
    #   }
    # }
  }
}