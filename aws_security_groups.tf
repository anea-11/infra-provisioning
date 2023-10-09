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
######################################################################

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
