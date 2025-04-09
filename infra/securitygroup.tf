resource "aws_security_group" "ze_elb_sg" {
  name        = "ze-elb-sg"
  description = "security group for elb"
  vpc_id      = aws_vpc.ze_vpc.id

  tags = {
    Name = "ze-elb-sg"
    Role = "Load Balancer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "elb_http_in" {
  security_group_id = aws_security_group.ze_elb_sg.id
  description       = "Allow HTTP from anywhere"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "elb_to_instances" {
  security_group_id            = aws_security_group.ze_elb_sg.id
  description                  = "Allow outbound to instances on HTTP"
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.ze_instances_sg.id
}

resource "aws_security_group" "ze_instances_sg" {
  name        = "ze-sg"
  description = "security group for instances"
  vpc_id      = aws_vpc.ze_vpc.id

  tags = {
    Name = "ze-instance-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "instances_from_elb" {
  security_group_id            = aws_security_group.ze_instances_sg.id
  description                  = "Allow HTTP from ELB"
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.ze_elb_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "instances_ssh" {
  security_group_id = aws_security_group.ze_instances_sg.id
  description       = "Allow SSH from you computer" #Edit this with your local computer IP.
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "165.225.20.175/32"
}

resource "aws_vpc_security_group_egress_rule" "instances_http_out" {
  security_group_id = aws_security_group.ze_instances_sg.id
  description       = "Allow outbound HTTP"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "instance_https_out" {
  security_group_id = aws_security_group.ze_instances_sg.id
  description       = "Allow outbound HTTPS"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "instance_ephemeral_out" {
  security_group_id = aws_security_group.ze_instances_sg.id
  description       = "Allow ephemeral ports for ELB responses"
  ip_protocol       = "tcp"
  from_port         = 1024
  to_port           = 65535
  cidr_ipv4         = "0.0.0.0/0"
}