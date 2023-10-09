######################################################
# UTILITY
######################################################
resource "aws_instance" "jenkins-server" {
  ami                    = "ami-0329d3839379bfd15"
  instance_type          = "t4g.small"
  subnet_id              = aws_subnet.dev_utility_subnet.id
  vpc_security_group_ids = [aws_security_group.development_allow_ssh_icmp.id, aws_security_group.development_jenkins_ingress.id]
  key_name               = "admin-ssh-key"
  depends_on             = [aws_internet_gateway.development_vpc_gateway]

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "nexus-server" {
  ami                    = "ami-0329d3839379bfd15"
  instance_type          = "t4g.medium"
  subnet_id              = aws_subnet.dev_utility_subnet.id
  vpc_security_group_ids = [aws_security_group.development_allow_ssh_icmp.id]
  key_name               = "admin-ssh-key"
  depends_on             = [aws_internet_gateway.development_vpc_gateway]

  tags = {
    Name = "nexus-server"
  }
}

######################################################
# APPLICATION: ENCODING
######################################################
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
