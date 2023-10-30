terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

resource "aws_vpc" "development_vpc" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "development_vpc"
  }
}

resource "aws_subnet" "dev_utility_subnet" {
  vpc_id                  = aws_vpc.development_vpc.id
  cidr_block              = "172.16.0.0/24"
  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev_utility_subnet"
  }
}

resource "aws_internet_gateway" "development_vpc_gateway" {
  vpc_id = aws_vpc.development_vpc.id

  tags = {
    Name = "development_vpc_gateway"
  }
}

resource "aws_route_table" "development_route_table" {
  vpc_id = aws_vpc.development_vpc.id

  tags = {
    Name = "development_route_table"
  }
}

resource "aws_route" "development_route_1" {
  route_table_id         = aws_route_table.development_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.development_vpc_gateway.id
}

resource "aws_route_table_association" "development_route_table_association" {
  subnet_id      = aws_subnet.dev_utility_subnet.id
  route_table_id = aws_route_table.development_route_table.id
}

resource "aws_security_group" "development_allow_ssh_icmp" {
  name        = "development_allow_ssh_icmp"
  description = "Allow SSH and ICMP inbound traffic"
  vpc_id      = aws_vpc.development_vpc.id

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Inbound ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "development_allow_ssh_icmp"
  }
}

resource "aws_security_group" "development_jenkins_ingress" {
  name        = "development_jenkins_ingress"
  description = "Development jenkins ingress"
  vpc_id      = aws_vpc.development_vpc.id

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "development_jenkins_ingress"
  }
}

resource "aws_security_group" "development_nexus_ingress" {
  name        = "development_nexus_ingress"
  description = "Development nexus ingress"
  vpc_id      = aws_vpc.development_vpc.id

  ingress {
    description = "Nexus"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "development_nexus_ingress"
  }
}

resource "aws_instance" "jenkins-server" {
  ami                    = "ami-0329d3839379bfd15"
  instance_type          = "t4g.small"
  subnet_id              = aws_subnet.dev_utility_subnet.id
  vpc_security_group_ids = [aws_security_group.development_allow_ssh_icmp.id, aws_security_group.development_jenkins_ingress.id]
  key_name               = "admin-ssh-key"
  depends_on             = [aws_internet_gateway.development_vpc_gateway]

  root_block_device {
    volume_size = 16
  }

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "nexus-server" {
  ami                    = "ami-04e601abe3e1a910f"
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.dev_utility_subnet.id
  vpc_security_group_ids = [aws_security_group.development_allow_ssh_icmp.id, aws_security_group.development_nexus_ingress.id]
  key_name               = "admin-ssh-key"
  depends_on             = [aws_internet_gateway.development_vpc_gateway]

  root_block_device {
    volume_size = 16
  }

  tags = {
    Name = "nexus-server"
  }
}
