resource "aws_security_group_rule" "development_ssh_ingress_rule1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.development_ssh_ingress.id
}

resource "aws_security_group_rule" "development_ssh_ingress_rule2" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.development_ssh_ingress.id
}

resource "aws_security_group" "development_ssh_ingress" {
  name        = "development_ssh_ingress"
  description = "Allow SSH access in development VPC"
  vpc_id      = aws_vpc.development_vpc.id
}
######################################################################

resource "aws_security_group_rule" "encoding_ssh_ingress_rule1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.encoding_ssh_ingress.id
}

resource "aws_security_group_rule" "encoding_ssh_ingress_rule2" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.encoding_ssh_ingress.id
}

resource "aws_security_group" "encoding_ssh_ingress" {
  name        = "encoding_ssh_ingress"
  description = "Allow SSH access in encoding VPC"
  vpc_id      = aws_vpc.encoding_vpc.id
}
######################################################################

resource "aws_security_group_rule" "encoding_frontend_ingress_rule" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.encoding_frontend_ingress.id
}

resource "aws_security_group" "encoding_frontend_ingress" {
  name        = "encoding_frontend_ingress"
  description = "Access encoding app frontend"
  vpc_id      = aws_vpc.encoding_vpc.id
}

