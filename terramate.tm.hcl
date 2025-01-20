import {
  source = "/imports/mixins/*.tm.hcl"
}

globals "project" {
  name            = "terramate"
  confidentiality = "C3"
  securityZone    = "I-A"
}

globals "terraform" {
  version = "> 1.0"
}

# Following Globals are Standards. You should not need to change anything below.
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

