terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

resource "aws_vpc" "network_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "network_subnet" {
  vpc_id                  = aws_vpc.network_vpc.id
  cidr_block              = var.vpc_cidr_block
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}_subnet"
  }
}

resource "aws_internet_gateway" "network_vpc_gateway" {
  vpc_id = aws_vpc.network_vpc.id

  tags = {
    Name = "${var.vpc_name}_gateway"
  }
}

resource "aws_route_table" "network_route_table" {
  vpc_id = aws_vpc.network_vpc.id

  tags = {
    Name = "${var.vpc_name}_route_table"
  }
}

resource "aws_route" "network_route_1" {
  route_table_id         = aws_route_table.network_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.network_vpc_gateway.id
}

resource "aws_route_table_association" "network_route_table_association" {
  subnet_id      = aws_subnet.network_subnet.id
  route_table_id = aws_route_table.network_route_table.id
}

