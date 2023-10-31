variable "vpc_cidr_block" {
    description = "CIDR block for the network VPC"
    type        = string
}

variable "vpc_name" {
    description = "Network VPC name"
    type        = string
}

variable "az" {
    description = "Availability zone in which the network will be deployed"
    type        = string
}