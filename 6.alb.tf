
resource "aws_lb" "test" {
  name               = "test-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]


  tags = local.alb_tags
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_1.id
}

# This resource links your EC2 instance to your target group.
resource "aws_lb_target_group_attachment" "test" {
  for_each = aws_instance.first7

  target_group_arn = aws_lb_target_group.test.arn
  target_id        = each.value.id # Use the ID of the current instances in the loop
  port             = 80
}


resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.test.arn # Connects to the load balancer
  port              = "80"
  protocol          = "HTTP"

  # This is the default rule: forward all traffic to our target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}


