variable "vpc_cidr_block" {
    description = "CIDR block for the VPC in which encoding-app resources will be deployed"
    type        = string
}

variable "vpc_name" {
    description = "Name for the VPC in which encoding-app resources will be deployed"
    type        = string
}

variable "az" {
    description = "Availability zone in which the resources will be deployed"
    type        = string
}

variable "encoding_server_ami" {
    description = "Encoding server AMI"
    type        = string
}

variable "encoding_server_instance_type" {
    description = "Encoding server instance type"
    type        = string
}
