resource "aws_vpc" "encoding_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "encoding_vpc"
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

resource "aws_internet_gateway" "encoding_vpc_gateway" {
  vpc_id = aws_vpc.encoding_vpc.id

  tags = {
    Name = "encoding_vpc_gateway"
  }
}

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

resource "aws_route_table_association" "encoding_route_table_association" {
  subnet_id      = aws_subnet.encoding_app_subnet.id
  route_table_id = aws_route_table.encoding_route_table.id
}

resource "aws_security_group" "encoding_allow_ssh_icmp" {
  name        = "encoding_allow_ssh_icmp"
  description = "Allow SSH and ICMP inbound traffic"
  vpc_id      = aws_vpc.encoding_vpc.id

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
  vpc_id      = aws_vpc.encoding_vpc.id

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

resource "aws_instance" "encoding-server-1" {
  ami                    = "ami-0329d3839379bfd15"
  instance_type          = "t4g.small"
  subnet_id              = aws_subnet.encoding_app_subnet.id
  vpc_security_group_ids = [aws_security_group.encoding_allow_ssh_icmp.id, aws_security_group.encoding_frontend_ingress.id]
  key_name               = "admin-ssh-key"
  depends_on             = [aws_internet_gateway.encoding_vpc_gateway]

  tags = {
    Name = "encoding-server-1"
  }
}
