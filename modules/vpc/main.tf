resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cider
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  count      = var.az_count
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  # availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.vpc.id
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count      = var.az_count
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, var.az_count + count.index)
  # availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

# resource "aws_subnet" "sn1" {
#   cidr_block              = "10.0.1.0/24"
#   vpc_id                  = aws_vpc.vpc.id
#   availability_zone       = "us-east-2a"
#   map_public_ip_on_launch = true
# }

# resource "aws_subnet" "sn2" {
#   cidr_block              = "10.0.2.0/24"
#   vpc_id                  = aws_vpc.vpc.id
#   availability_zone       = "us-east-2b"
#   map_public_ip_on_launch = true
# }

# resource "aws_subnet" "sn3" {
#   cidr_block              = "10.0.3.0/24"
#   vpc_id                  = aws_vpc.vpc.id
#   availability_zone       = "us-east-2c"
#   map_public_ip_on_launch = true
# }

# resource "aws_security_group" "sg" {
#   name   = "sg"
#   vpc_id = aws_vpc.vpc.id

#   ingress {
#     description = "https"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "http"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.vpc.id
# }

# resource "aws_route_table" "rt" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   route {
#     ipv6_cidr_block = "::/0"
#     gateway_id      = aws_internet_gateway.gw.id
#   }
# }

# resource "aws_route_table_association" "route1" {
#   route_table_id = aws_route_table.rt.id
#   subnet_id      = aws_subnet.sn1.id
# }

# resource "aws_route_table_association" "route2" {
#   route_table_id = aws_route_table.rt.id
#   subnet_id      = aws_subnet.sn2.id
# }

# resource "aws_route_table_association" "route3" {
#   route_table_id = aws_route_table.rt.id
#   subnet_id      = aws_subnet.sn3.id
# }
