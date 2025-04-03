resource "aws_security_group" "ze_sg" {
  name        = "ze-sg"
  description = "security group for ze"
  vpc_id      = aws_vpc.ze_vpc.id
}

resource "aws_vpc_security_group_egress_rule" "ssm_https_only" {
  security_group_id = aws_security_group.ze_sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTPS egress for SSM Agent"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_https" {
  security_group_id = aws_security_group.ze_sg.id

  cidr_ipv4   = "165.225.20.165/32"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_http" {
  security_group_id = aws_security_group.ze_sg.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "pubsub_1_ssm" {
  security_group_id = aws_security_group.ze_sg.id
  description       = "Allow ssm traffic"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ipv4   = aws_subnet.ze_pubsbn_1.cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "pub_sub_2_ssm" {
  security_group_id = aws_security_group.ze_sg.id
  description       = "Allow ssm traffic"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ipv4   = aws_subnet.ze_pubsbn_2.cidr_block
}