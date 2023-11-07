terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

data "aws_availability_zones" "azs" {}

module "google_online_boutique_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name              = var.vpc_name
  cidr              = var.vpc_cidr_block
  private_subnets   = var.vpc_private_subnets
  public_subnets    = var.vpc_public_subnets
  azs               = data.aws_availability_zones.azs.names

  enable_nat_gateway    = true
  single_nat_gateway    = true
  enable_dns_hostnames  = true

  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared" 
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared" 
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "google_online_boutique_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.4"

  cluster_name = "${var.eks_cluster_name}"
  cluster_version = "1.28"

  subnet_ids = module.google_online_boutique_vpc.private_subnets
  vpc_id = module.google_online_boutique_vpc.vpc_id

  eks_managed_node_groups = {
    online_boutique = {
        min_size = 1
        max_size = 3
        desired_size = 3

        instance_types = ["t3.large"]
    }
  }

  cluster_endpoint_public_access = true

  manage_aws_auth_configmap = true
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::474024458802:root"
      username = "root"
      groups   : [
        "system:nodes", "system:masters"
      ]
    }
  ]
}

########################################################################################################
# IMPORTANT: following code block will give an error when EKS cluster is not yet initialized!
# In other words, it throws an error if terraform apply needs to create the EKS cluster.
# Once the cluster already exists, the code works fine and athenticates with the cluster so that aws-auth configmap can be updated.
# Workaround: comment-out the problematic code -> run terraform apply -> uncomment the problematic code-> run terraform apply again

data "aws_eks_cluster" "default" {
  name = module.google_online_boutique_eks.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = module.google_online_boutique_eks.cluster_name
}

# Authenticate with the cluster to be able to update aws-auth configmap with tf
provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

# end of code that gives errors when EKS cluster is not yet initialized
########################################################################################################