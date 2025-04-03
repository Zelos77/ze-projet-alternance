/* 
#If you have a default VPC on your aws account, use this
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
} 
*/

resource "aws_vpc" "ze_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    environment = "dev"
    Name        = "ze-vpc"
  }
}

resource "aws_subnet" "ze_pubsbn_1" {

  vpc_id            = aws_vpc.ze_vpc.id
  cidr_block        = "10.0.0.0/26"
  availability_zone = var.az_euw[0]

  tags = {
    Name = "ze-public1-projet-alternance"
  }
}

resource "aws_subnet" "ze_pubsbn_2" {
  vpc_id            = aws_vpc.ze_vpc.id
  cidr_block        = "10.0.0.64/26"
  availability_zone = var.az_euw[1]

  tags = {
    Name = "ze-public2-projet-alternance"
  }
}

resource "aws_subnet" "ze_pvtsbn_1" {
  vpc_id            = aws_vpc.ze_vpc.id
  cidr_block        = "10.0.0.128/26"
  availability_zone = var.az_euw[0]

  tags = {
    Name = "ze-private1-projet-alternance"
  }
}

resource "aws_subnet" "ze_pvtsbn_2" {
  vpc_id            = aws_vpc.ze_vpc.id
  cidr_block        = "10.0.0.192/26"
  availability_zone = var.az_euw[1]

  tags = {
    Name = "ze-private2-projet-alternance"
  }
}

resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.ze_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ze_igw.id
  }

  tags = {
    Name = "ze-public-route-table"
  }

}

resource "aws_route_table" "pvt_route_table" {
  vpc_id = aws_vpc.ze_vpc.id
  tags = {
    Name = "ze-private-route-table"
  }
}

resource "aws_internet_gateway" "ze_igw" {
  vpc_id = aws_vpc.ze_vpc.id

  tags = {
    Name = "ze-igw"
  }
}

resource "aws_route_table_association" "pub_route_1_association" {
  route_table_id = aws_route_table.pub_route_table.id
  subnet_id      = aws_subnet.ze_pubsbn_1.id
}

resource "aws_route_table_association" "pub_route_2_association" {
  route_table_id = aws_route_table.pub_route_table.id
  subnet_id      = aws_subnet.ze_pubsbn_2.id
}

resource "aws_route_table_association" "pvt_route_1_association" {
  route_table_id = aws_route_table.pvt_route_table.id
  subnet_id      = aws_subnet.ze_pvtsbn_1.id
}

resource "aws_route_table_association" "pvt_route_2_association" {
  route_table_id = aws_route_table.pvt_route_table.id
  subnet_id      = aws_subnet.ze_pvtsbn_2.id
}

resource "aws_network_acl_association" "ze_nacl_pub1" {
  subnet_id      = aws_subnet.ze_pubsbn_1.id
  network_acl_id = aws_network_acl.ze_acl.id
}

resource "aws_network_acl_association" "ze_nacl_pub2" {
  subnet_id      = aws_subnet.ze_pubsbn_2.id
  network_acl_id = aws_network_acl.ze_acl.id
}

resource "aws_network_acl" "ze_acl" {
  vpc_id = aws_vpc.ze_vpc.id

  tags = {
    Name = "ze-acl"
  }
}

resource "aws_network_acl_rule" "ingress_http" {
  network_acl_id = aws_network_acl.ze_acl.id
  rule_number    = 100 # <-- Numéro plus petit = évalué en premier
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}
resource "aws_network_acl_rule" "ingress_ssh" {
  network_acl_id = aws_network_acl.ze_acl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "165.225.20.165/32"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "ingress_ephemere" {
  network_acl_id = aws_network_acl.ze_acl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}
resource "aws_network_acl_rule" "egress_http" {
  network_acl_id = aws_network_acl.ze_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "egress_https" {
  network_acl_id = aws_network_acl.ze_acl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "egress_ephemere" {
  network_acl_id = aws_network_acl.ze_acl.id
  rule_number    = 120
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Create a new load balancer
resource "aws_elb" "ze_elb" {
  name               = "ze-elb-projet-alternance"
  subnets            = [aws_subnet.ze_pubsbn_1.id, aws_subnet.ze_pubsbn_2.id]
  security_groups    = [aws_security_group.ze_sg.id]



  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.ze_instance_blue.id, aws_instance.ze_instance_red.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}

output "dns_name" {
  value = aws_elb.ze_elb.dns_name
}