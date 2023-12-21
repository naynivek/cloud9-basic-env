## CREATE VPC ##
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "vpc-${var.project}"
  }
}

## CREATE VPC - SG ##
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "vpc-${var.project}-sg"
  }
}

## CREATE SUBNET - TGW ##
resource "aws_subnet" "tgw" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.tgw_subnets[count.index]
  availability_zone = element(local.azs[*], count.index)

  tags = {
    Name = "tgw-${element(local.azs[*], count.index)}"
  }
}

## CREATE SUBNET - BACKEND ##
resource "aws_subnet" "backend" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.backend_subnet[count.index]
  availability_zone = element(local.azs[*], count.index)

  tags = {
    Name = "backend-${element(local.azs[*], count.index)}"
  }
}

## CREATE SUBNET - DATABASE ##
resource "aws_subnet" "database" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.database_subnet[count.index]
  availability_zone = element(local.azs[*], count.index)

  tags = {
    Name = "database-${element(local.azs[*], count.index)}"
  }
}

## CREATE IGW
resource "aws_internet_gateway" "outbound_igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "outbound_igw-${var.project}"
  }
}

## CREATE EXTERNAL ROUTE TABLE ##
resource "aws_route_table" "this_external" {
  count  = length(aws_subnet.tgw[*].id)
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "external-rtb-${aws_subnet.tgw[count.index].availability_zone}"
  }
}

resource "aws_route_table_association" "tgw_external" {
  count          = length(aws_subnet.tgw[*].id)
  subnet_id      = element(aws_subnet.tgw[*].id, count.index)
  route_table_id = aws_route_table.this_external[count.index].id
}

resource "aws_route_table_association" "backend_external" {
  count          = length(aws_subnet.backend[*].id)
  subnet_id      = element(aws_subnet.backend[*].id, count.index)
  route_table_id = aws_route_table.this_external[count.index].id
}

resource "aws_route" "outbound_default_igw" {
  count          = length(aws_subnet.backend[*].id)
  route_table_id         = aws_route_table.this_external[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id      = aws_internet_gateway.outbound_igw.id
}