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

resource "aws_vpc" "testing_p1_vpc" {
  cidr_block       = "172.17.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "testing_p1_vpc"
  }
}

####################################################################
# SUBNETS
####################################################################
resource "aws_subnet" "dev_utility_subnet" {
    vpc_id              = aws_vpc.development_vpc.id
    cidr_block          = "172.16.0.0/24"
    availability_zone   = "eu-central-1c"

    tags = {
        Name = "dev_utility_subnet"
    }
}
