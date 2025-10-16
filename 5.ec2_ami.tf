data "aws_ami" "amazon_linux" {
  most_recent = true       # this ensures that the most up-to-date version of the AMI is retreived
  owners      = ["amazon"] # this is a critical security filter to ensure we only get official, trusted images.

  filter {
    name   = "name"                                #this wildcard pattern matches the heading for AMI for Amazin Lnexs AMI  
    values = ["al2023-ami-2023.*-kernel-*-x86_64"] #note that the '*' abstracts various changable numbers, like creation date and version number
  }
}

resource "aws_instance" "first7" {
  for_each = var.public_subnets

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true

  subnet_id = aws_subnet.public_subnet[each.key].id
  # Links the instance to our security group
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  tags = local.ec2_tags[each.key]

  # On first boot, run a script to install our web server software.
  # the 'file' fucntion references the file path given, 'path.module' sets the path for the following '/<file>'
  # since ultimate file path for the user data now involves a map, you reference the particular script the the [each.ky], please reference the 
  user_data = file("${path.module}/${var.user_data_script[each.key]}")

}
