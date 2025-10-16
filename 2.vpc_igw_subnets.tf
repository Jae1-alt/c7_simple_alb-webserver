resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_1.id

  tags = local.vpc_tags
}

resource "aws_vpc" "main_1" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.vpc_tags
}

data "aws_availability_zones" "public_az" { #this data
  state  = "available"
  region = var.region
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main_1.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = data.aws_availability_zones.public_az.names[each.value]

  map_public_ip_on_launch = true

  tags = local.subnet_tags[each.key]
}

