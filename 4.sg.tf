resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow http & ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main_1.id

  tags = {
    Name = "allow_http_ssh"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_http_from_alb" {
  security_group_id = aws_security_group.allow_http_ssh.id
  # This is the key: it references the ALB's security group as the source
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

# this rule allows direct SSH connection to the instance, not through ALB
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = var.ingress_ipv4_ssh
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

/* 
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = var.ingress_ipv4_http
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
} */

/* # no variables for you, DO NOT TOUCH OUTBOUND RULES
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
} */

# Rule to allow ALL outbound traffic from the ALB
resource "aws_vpc_security_group_egress_rule" "allow_all_from_alb" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}