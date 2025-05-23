resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
    tags = merge(
    var.tags,
    {
      Name = "VPC"
    }
  )
}

resource "aws_subnet" "network_public" {
  count = length(var.network_public_subnets)  
  vpc_id = aws_vpc.main.id
  cidr_block = var.network_public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    {
      Name = "network-public-subnet-${count.index + 1}"
      AvailabilityZone = var.availability_zones[count.index]
    }
  )
}

resource "aws_subnet" "network_private" {
  count = length(var.network_private_subnets)  
  vpc_id = aws_vpc.main.id
  cidr_block = var.network_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge(
    var.tags,
    {
      Name = "network-private-subnet-${count.index + 1}"
      AvailabilityZone = var.availability_zones[count.index]
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = "IGW"
    }
  )
}

resource "aws_eip" "to_nat" {
  count = length(var.network_public_subnets)
  domain = "vpc"
  tags = merge(
    var.tags,
    {
      Name = "eip-to-nat-${count.index + 1}"
    }
  ) 
}

resource "aws_nat_gateway" "main" {
  count = length(var.network_public_subnets)
  allocation_id = aws_eip.to_nat[count.index].id
  subnet_id = aws_subnet.network_public[count.index].id
  tags = merge(
    var.tags,
    {
      Name = "nat-gateway-${count.index + 1}"
    }
  )
  depends_on = [aws_internet_gateway.main, aws_eip.to_nat]
}

resource "aws_route_table" "network_public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(
    var.tags,
    {
      Name = "ec2-public-rt"
    }
  )
}

resource "aws_route_table_association" "network_public_rt_association" {
  count = length(var.network_public_subnets)
  subnet_id = aws_subnet.network_public[count.index].id
  route_table_id = aws_route_table.network_public_rt.id
}

resource "aws_route_table" "network_private_rt" {
  count = length(var.network_private_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  tags = merge(
    var.tags,
    {
      Name = "rds-private-rt-${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "network_private_rt_association" {
  count = length(var.network_private_subnets)
  subnet_id = aws_subnet.network_private[count.index].id
  route_table_id = aws_route_table.network_private_rt[count.index].id
}


