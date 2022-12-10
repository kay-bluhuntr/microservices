# ==============================================================================
# Context

locals {
  aurora_engine_major_version = element((split(".", var.aurora_engine_version)), 0)
  context = {

    tags = {
      Environment = var.environment
    }

  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
  version = ">= 3.74.1, < 4.0.0"
}

