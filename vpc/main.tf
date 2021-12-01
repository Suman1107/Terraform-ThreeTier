#-----vpc/main.tf-----

data "aws_availability_zones" "availibilty_zones" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "custom vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "random_shuffle" "azs" {
  input        = data.aws_availability_zones.availibilty_zones.names
  result_count = var.max_az_count
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.azs.result[count.index]
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.azs.result[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-internet_gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}

resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}


#----------- dababase subnet group ---------

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds_subnet_group"
  subnet_ids = aws_subnet.private_subnet.*.id
  tags = {
    Name = "RDS subnets"
  }
}
