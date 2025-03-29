resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cider
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "project"
  }

}

resource "aws_subnet" "private" {
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  # availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private"
  }

}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, var.az_count + count.index)
  # availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "Public"
  }

}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Project-IGW"
  }

}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gw" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gw" {
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
