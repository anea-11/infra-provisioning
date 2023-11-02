terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

module "encoding_public_network" {
  source = "../aws_public_network"

  vpc_cidr_block  = var.vpc_cidr_block
  vpc_name        = var.vpc_name
  az              = var.az
}

resource "aws_security_group" "encoding_allow_ssh_icmp" {
  name        = "encoding_allow_ssh_icmp"
  description = "Allow SSH and ICMP inbound traffic"
  vpc_id      = module.encoding_public_network.vpc_id

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
    Name = "encoding_allow_ssh_icmp"
  }
}

resource "aws_security_group" "encoding_frontend_ingress" {
  name        = "encoding_frontend_ingress"
  description = "Encoding frontend ingress"
  vpc_id      = module.encoding_public_network.vpc_id

  ingress {
    description = "Encoding frontend"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "encoding_frontend_ingress"
  }
}

resource "aws_instance" "encoding-server" {
  ami                    = var.encoding_server_ami
  instance_type          = var.encoding_server_instance_type
  subnet_id              = module.encoding_public_network.subnet_id
  vpc_security_group_ids = [aws_security_group.encoding_allow_ssh_icmp.id, aws_security_group.encoding_frontend_ingress.id]
  key_name               = "admin-ssh-key"
  depends_on             = [module.encoding_public_network.internet_gateway]

  tags = {
    Name = "encoding-server-1"
  }
}
