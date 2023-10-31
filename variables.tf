variable "aws_region" {
  description = "AWS region to deploy resources to"
  type        = string
}

variable "cicd_vpc_cidr_block" {
  description = "CIDR block for the VPC in which CICD resources will be deployed"
  type        = string
}

variable "cicd_vpc_name" {
  description = "Name for the VPC in which CICD resources will be deployed"
  type        = string
}

variable "cicd_az" {
  description = "Availability zone in which CICD resources will be deployed"
  type        = string
}

variable "encoding_app_vpc_cidr_block" {
  description = "CIDR block for the VPC in which encoding-app resources will be deployed"
  type        = string
}

variable "encoding_app_vpc_name" {
  description = "Name for the VPC in which encoding-app resources will be deployed"
  type        = string
}

variable "encoding_app_az" {
  description = "Availability zone in which encoding-app resources will be deployed"
  type        = string
}

variable "google_online_boutique_vpc_name" {
  description = "Name for the VPC in which google_online_boutigue app resources will be deployed"
  type        = string
}

variable "google_online_boutique_vpc_cidr_block" {
  description = "CIDR block for the VPC in which google_online_boutigue app resources will be deployed"
  type        = string
}

variable "google_online_boutique_vpc_private_subnets" {
  description = "Private subnets for the VPC in which google_online_boutigue app resources will be deployed"
  type        = list(string)
}

variable "google_online_boutique_vpc_public_subnets" {
  description = "Public subnets for the VPC in which google_online_boutigue app resources will be deployed"
  type        = list(string)
}

variable "google_online_boutique_eks_cluster_name" {
  description = "EKS cluster name for google_online_boutique app"
  type        = string
}
