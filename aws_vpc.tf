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