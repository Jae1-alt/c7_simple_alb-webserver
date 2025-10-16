# A security group JUST for the ALB
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.main_1.id
  tags   = { Name = "alb-sg" }
}

# Rule to allow HTTP traffic FROM THE INTERNET to the ALB
resource "aws_vpc_security_group_ingress_rule" "allow_http_to_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Rule to allow all outbound traffic from the ALB
resource "aws_vpc_security_group_egress_rule" "alb_allow_all" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

