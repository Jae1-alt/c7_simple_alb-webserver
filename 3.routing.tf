# Route Table for the VPC
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_1.id

  #the "default route" (0.0.0.0/0) that points to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name} public-route-table"
  }
}

# Associate the Route Table with the public subnet
resource "aws_route_table_association" "public_subnet_assoc" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_rt.id
}
