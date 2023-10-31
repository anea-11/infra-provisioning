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
  description = "Availability zone in which CICD resources will be deployed"
  type        = string
  default     = "eu-central-1c"
}

variable "encoding_app_vpc_cidr_block" {
  description = "CIDR block for the VPC in which encoding-app resources will be deployed"
  type        = string
  default     = "172.17.0.0/16"
}

variable "encoding_app_vpc_name" {
  description = "Name for the VPC in which encoding-app resources will be deployed"
  type        = string
  default     = "encoding_app_vpc"
}

variable "encoding_app_az" {
  description = "Availability zone in which encoding-app resources will be deployed"
  type        = string
  default     = "eu-central-1a"
}

variable "google_online_boutique_vpc_name" {
  description = "Name for the VPC in which google_online_boutigue app resources will be deployed"
  type        = string
  default     = "google_online_boutique_vpc"
}

variable "google_online_boutique_vpc_cidr_block" {
  description = "CIDR block for the VPC in which google_online_boutigue app resources will be deployed"
  type        = string
  default     = "172.18.0.0/16"
}

variable "google_online_boutique_vpc_private_subnets" {
  description = "Private subnets for the VPC in which google_online_boutigue app resources will be deployed"
  type        = list(string)
  default     = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
}

variable "google_online_boutique_vpc_public_subnets" {
  description = "Public subnets for the VPC in which google_online_boutigue app resources will be deployed"
  type        = list(string)
  default     = ["172.18.4.0/24", "172.18.5.0/24", "172.18.6.0/24"]
}