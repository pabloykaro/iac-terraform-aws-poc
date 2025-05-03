resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
    tags = merge(
    var.tags,
    {
      Name = "vpc"
    }
  )
}

resource "aws_subnet" "ec2_public" {
  count = length(var.ec2_public_subnets)  
  vpc_id = aws_vpc.main.id
  cidr_block = var.ec2_public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    {
      Name = "ec2-public-subnet-${count.index + 1}"
      AvailabilityZone = var.availability_zones[count.index]
    }
  )
}

resource "aws_subnet" "rds_private" {
  count = length(var.rds_private_subnets)  
  vpc_id = aws_vpc.main.id
  cidr_block = var.rds_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge(
    var.tags,
    {
      Name = "rds-private-subnet-${count.index + 1}"
      AvailabilityZone = var.availability_zones[count.index]
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = "igw"
    }
  )
}

resource "aws_eip" "to_nat" {
  count = length(var.ec2_public_subnets)
  domain = "vpc"
  tags = merge(
    var.tags,
    {
      Name = "ec2-public-eip-${count.index + 1}"
    }
  ) 
}

resource "aws_nat_gateway" "main" {
  count = length(var.ec2_public_subnets)
  allocation_id = aws_eip.to_nat[count.index].id
  subnet_id = aws_subnet.ec2_public[count.index].id
  tags = merge(
    var.tags,
    {
      Name = "rds-private-nat-${count.index + 1}"
    }
  )
  depends_on = [aws_internet_gateway.main, aws_eip.to_nat]
}

resource "aws_route_table" "ec2_public_rt" {
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

resource "aws_route_table_association" "ec2_public_rt_association" {
  count = length(var.ec2_public_subnets)
  subnet_id = aws_subnet.ec2_public[count.index].id
  route_table_id = aws_route_table.ec2_public_rt.id
}

resource "aws_route_table" "rds_private_rt" {
  count = length(var.rds_private_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.rds_private_nat[count.index].id
  }
  tags = merge(
    var.tags,
    {
      Name = "rds-private-rt-${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "rds_private_rt_association" {
  count = length(var.rds_private_subnets)
  subnet_id = aws_subnet.rds_private[count.index].id
  route_table_id = aws_route_table.rds_private_rt[count.index].id
}


