####################################################################
# VPCs
####################################################################
resource "aws_vpc" "development_vpc" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "development_vpc"
  }
}

resource "aws_vpc" "encoding_vpc" {
  cidr_block       = "172.17.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "encoding_vpc"
  }
}

####################################################################
# SUBNETS
####################################################################
resource "aws_subnet" "dev_utility_subnet" {
  vpc_id                  = aws_vpc.development_vpc.id
  cidr_block              = "172.16.0.0/24"
  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev_utility_subnet"
  }
}

resource "aws_subnet" "encoding_app_subnet" {
  vpc_id                  = aws_vpc.encoding_vpc.id
  cidr_block              = "172.17.0.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "encoding_app_subnet"
  }
}

####################################################################
# INTERNET GATEWAYS
####################################################################
resource "aws_internet_gateway" "development_vpc_gateway" {
  vpc_id = aws_vpc.development_vpc.id

  tags = {
    Name = "development_vpc_gateway"
  }
}

resource "aws_internet_gateway" "encoding_vpc_gateway" {
  vpc_id = aws_vpc.encoding_vpc.id

  tags = {
    Name = "encoding_vpc_gateway"
  }
}
