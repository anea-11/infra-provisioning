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
  region = "eu-central-1"
}

