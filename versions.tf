provider "aws" {
  alias  = "logs"
  region = local.logs_region
}

terraform {
  required_version = "~> 0.12.0"

  required_providers {
    aws   = "~> 2.12"
    local = "~> 1.2"
  }
}
