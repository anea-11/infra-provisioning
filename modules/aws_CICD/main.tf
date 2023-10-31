terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

module "cicd_public_network" {
  source = "../aws_public_network"

  vpc_cidr_block  = var.vpc_cidr_block
  vpc_name        = var.vpc_name
  az              = var.az
}

resource "aws_security_group" "cicd_allow_ssh_icmp" {
  name        = "cicd_allow_ssh_icmp"
  description = "Allow SSH and ICMP inbound traffic"
  vpc_id      = module.cicd_public_network.vpc_id

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
    Name = "cicd_allow_ssh_icmp"
  }
}

resource "aws_security_group" "cicd_jenkins_ingress" {
  name        = "cicd_jenkins_ingress"
  description = "CICD jenkins ingress"
  vpc_id      = module.cicd_public_network.vpc_id

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cicd_jenkins_ingress"
  }
}

resource "aws_security_group" "cicd_nexus_ingress" {
  name        = "cicd_nexus_ingress"
  description = "CICD nexus ingress"
  vpc_id      = module.cicd_public_network.vpc_id

  ingress {
    description = "Nexus"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cicd_nexus_ingress"
  }
}

resource "aws_instance" "jenkins-server" {
  ami                    = "ami-0329d3839379bfd15"
  instance_type          = "t4g.small"
  subnet_id              = module.cicd_public_network.subnet_id
  vpc_security_group_ids = [aws_security_group.cicd_allow_ssh_icmp.id, aws_security_group.cicd_jenkins_ingress.id]
  key_name               = "admin-ssh-key"
  depends_on             = [module.cicd_public_network.internet_gateway]

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
  subnet_id              = module.cicd_public_network.subnet_id
  vpc_security_group_ids = [aws_security_group.cicd_allow_ssh_icmp.id, aws_security_group.cicd_nexus_ingress.id]
  key_name               = "admin-ssh-key"
  depends_on             = [module.cicd_public_network.internet_gateway]

  root_block_device {
    volume_size = 16
  }

  tags = {
    Name = "nexus-server"
  }
}
