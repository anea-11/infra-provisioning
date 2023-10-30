####################################################################
# VPCs
####################################################################
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
resource "aws_internet_gateway" "encoding_vpc_gateway" {
  vpc_id = aws_vpc.encoding_vpc.id

  tags = {
    Name = "encoding_vpc_gateway"
  }
}

#######################################################################
# ROUTE TABLES
#######################################################################
resource "aws_route_table" "encoding_route_table" {
  vpc_id = aws_vpc.encoding_vpc.id

  tags = {
    Name = "encoding_route_table"
  }
}
resource "aws_route" "encoding_route_1" {
  route_table_id         = aws_route_table.encoding_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.encoding_vpc_gateway.id
}

#######################################################################
# SUBNET-ROUTE TABLE ASSOCIATIONS
#######################################################################
resource "aws_route_table_association" "encoding_route_table_association" {
  subnet_id      = aws_subnet.encoding_app_subnet.id
  route_table_id = aws_route_table.encoding_route_table.id
}
