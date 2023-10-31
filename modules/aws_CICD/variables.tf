variable "vpc_cidr_block" {
    description = "CIDR block for the VPC in which CICD resources will be deployed"
    type        = string
}

variable "vpc_name" {
    description = "Name for the VPC in which CICD resources will be deployed"
    type        = string
}

variable "az" {
    description = "Availability zone in which the resources will be deployed"
    type        = string
}