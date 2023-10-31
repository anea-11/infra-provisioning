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

module "CICD_resources" {
  source = "./modules/aws_CICD"

  vpc_cidr_block = var.cicd_vpc_cidr_block
  vpc_name       = var.cicd_vpc_name
  az             = var.cicd_az
}

module "encoding_app_resources" {
  source = "./modules/aws_encoding_app"

  vpc_cidr_block = var.encoding_app_vpc_cidr_block
  vpc_name       = var.encoding_app_vpc_name
  az             = var.encoding_app_az
}

module "google_online_boutique_resources" {
  source = "./modules/aws_google_online_boutique"

  vpc_cidr_block      = var.google_online_boutique_vpc_cidr_block
  vpc_name            = var.google_online_boutique_vpc_name
  vpc_private_subnets = var.google_online_boutique_vpc_private_subnets
  vpc_public_subnets  = var.google_online_boutique_vpc_public_subnets
}
