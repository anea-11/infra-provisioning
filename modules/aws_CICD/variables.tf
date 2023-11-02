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

variable "jenkins_server_ami" {
    description = "Jenkins server AMI"
    type        = string
}

variable "jenkins_server_instance_type" {
    description = "Jenkins server instance type"
    type        = string
}

variable "nexus_server_ami" {
    description = "Nexus server AMI"
    type        = string
}

variable "nexus_server_instance_type" {
    description = "Nexus server instance type"
    type        = string
}