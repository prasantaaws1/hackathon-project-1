# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    "Name" = "my_vpc"
  }
}

resource "aws_subnet" "private" {
  # count             = var.az_count
  cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8)
  # availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.my_vpc.id
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  # count                   = var.az_count
  cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8)
  # availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.my_vpc.id
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # public 
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "MyRouteTable"
  }
}

# Route Table Association
resource "aws_route_table_association" "rta" {
  count          = length(var.subnet_cidr)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rt.id
}
