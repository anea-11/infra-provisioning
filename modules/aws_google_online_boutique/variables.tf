variable vpc_name  {
    description = "Name for the VPC in which google_online_boutigue app resources will be deployed"
    type        = string
}

variable vpc_cidr_block  {
    description = "CIDR block for the VPC in which google_online_boutigue app resources will be deployed"
    type        = string
}

variable vpc_private_subnets  {
    description = "Private subnets for the VPC in which google_online_boutigue app resources will be deployed"
    type        = list(string)
}

variable vpc_public_subnets  {
    description = "Public subnets for the VPC in which google_online_boutigue app resources will be deployed"
    type        = list(string)
}

variable eks_cluster_name  {
    description = "EKS cluster name"
    type        = string
}
