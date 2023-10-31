variable "aws_region" {
  description = "AWS region to deploy resources to"
  type        = string
  default     = "eu-central-1"
}

variable "cicd_vpc_cidr_block" {
  description = "CIDR block for the VPC in which CICD resources will be deployed"
  type        = string
  default     = "172.16.0.0/16"
}

variable "cicd_vpc_name" {
  description = "Name for the VPC in which CICD resources will be deployed"
  type        = string
  default     = "cicd_vpc"
}

variable "cicd_az" {
  description = "Availability zone in which the resources will be deployed"
  type        = string
  default     = "eu-central-1c"
}

variable "encoding_app_vpc_cidr_block" {
  description = "CIDR block for the VPC in which encoding-app resources will be deployed"
  type        = string
  default     = "172.17.0.0/16"
}