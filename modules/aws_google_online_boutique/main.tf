terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
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
}

module "google_online_boutique_efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.3.1"

  name = "efs-name"

  create_security_group = true
  security_group_vpc_id = module.google_online_boutique_vpc.vpc_id
  security_group_rules =  {
    ingress = {
      type        = "ingress"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  mount_targets = {
    t1 = {
      subnet_id = module.google_online_boutique_vpc.private_subnets[0]
    },
    t2 = {
      subnet_id = module.google_online_boutique_vpc.private_subnets[1]
    },
    t3 = {
      subnet_id = module.google_online_boutique_vpc.private_subnets[2]
    }
  }
}