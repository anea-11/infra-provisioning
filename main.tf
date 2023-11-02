terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }

  backend "s3" {
    bucket = "ttt-tfstates"
    region = "eu-central-1" # don't modify this

    # Uncomment and run "terraform init" to select region-specific state file
    key = "eu-west-1/terraform.tfstate"
    # key    = "eu-central-1/terraform.tfstate"
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

  jenkins_server_ami           = var.cicd_jenkins_server_ami
  jenkins_server_instance_type = var.cicd_jenkins_server_instance_type
  nexus_server_ami             = var.cicd_nexus_server_ami
  nexus_server_instance_type   = var.cicd_nexus_server_instance_type
}

module "encoding_app_resources" {
  source = "./modules/aws_encoding_app"

  vpc_cidr_block = var.encoding_app_vpc_cidr_block
  vpc_name       = var.encoding_app_vpc_name
  az             = var.encoding_app_az

  encoding_server_ami           = var.encoding_app_server_ami
  encoding_server_instance_type = var.encoding_app_server_instance_type
}

module "google_online_boutique_resources" {
  source = "./modules/aws_google_online_boutique"

  vpc_cidr_block      = var.google_online_boutique_vpc_cidr_block
  vpc_name            = var.google_online_boutique_vpc_name
  vpc_private_subnets = var.google_online_boutique_vpc_private_subnets
  vpc_public_subnets  = var.google_online_boutique_vpc_public_subnets

  eks_cluster_name = var.google_online_boutique_eks_cluster_name
}
