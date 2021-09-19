terraform {
  required_version = "~> 0.14.0"

  backend "s3" {
    # bucket = "CHANGEME"
    # key    = "nginx-server/prod/terraform.tfstate"
    # region = "CHANGEME"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
