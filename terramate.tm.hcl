
# Terramate settings in this file should not be changed.
# Check configs.tm.hcl for project level configs.

import {
  source = "/imports/mixins/*.tm.hcl"
}

globals "backend" {
  bucket         = "iot-terraform-shared-state-storage-s3"
  dynamodb_table = "terraform-state-lock-dynamo"
  region         = "eu-west-1"
  key            = "project/${global.project.name}"
  profile        = "root"
}

terramate {
  required_version = ">= 0.11.1"

  config {
    experiments = [
      "scripts",
      "outputs-sharing"
    ]
  }
}

