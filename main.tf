terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

# env: AWS_ACCESS_KEY_ID
# env: AWS_SECRET_ACCESS_KEY
provider "aws" {
  region = var.aws_region
}

module "aws_CICD" {
  source = "./modules/aws_CICD"
}

module "aws_encoding_app" {
  source = "./modules/aws_encoding_app"
}
