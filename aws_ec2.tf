######################################################
# UTILITY
######################################################
resource "aws_instance" "jenkins-server" {
  ami             = "ami-0329d3839379bfd15"
  instance_type   = "t4g.small"
  subnet_id       = aws_subnet.dev_utility_subnet.id
  security_groups = [aws_security_group.development_ssh_ingress.id]
  key_name        = "admin-key"

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "nexus-server" {
  ami             = "ami-0329d3839379bfd15"
  instance_type   = "t4g.medium"
  subnet_id       = aws_subnet.dev_utility_subnet.id
  security_groups = [aws_security_group.development_ssh_ingress.id]
  key_name        = "admin-key"

  tags = {
    Name = "nexus-server"
  }
}

######################################################
# APPLICATION: ENCODING
######################################################
resource "aws_instance" "encoding-server-1" {
  ami             = "ami-0329d3839379bfd15"
  instance_type   = "t4g.small"
  subnet_id       = aws_subnet.encoding_app_subnet.id
  security_groups = [aws_security_group.encoding_ssh_ingress.id, aws_security_group.encoding_frontend_ingress.id]
  key_name        = "admin-key"

  tags = {
    Name = "encoding-server-1"
  }
}
