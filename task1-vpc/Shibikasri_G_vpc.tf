Provider

provider "aws" {
  region = "us-east-1"
}

VPC
resource "aws_vpc" "shibikasri_g_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Shibikasri_G_VPC"
  }
}

Public Subnets
resource "aws_subnet" "shibikasri_g_public_1" {
  vpc_id                  = aws_vpc.shibikasri_g_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Shibikasri_G_Public_1"
  }
}

resource "aws_subnet" "shibikasri_g_public_2" {
  vpc_id                  = aws_vpc.shibikasri_g_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Shibikasri_G_Public_2"
  }
}
Private Subnets
resource "aws_subnet" "shibikasri_g_private_1" {
  vpc_id            = aws_vpc.shibikasri_g_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Shibikasri_G_Private_1"
  }
}

resource "aws_subnet" "shibikasri_g_private_2" {
  vpc_id            = aws_vpc.shibikasri_g_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Shibikasri_G_Private_2"
  }
}
Internet Gateway
resource "aws_internet_gateway" "shibikasri_g_igw" {
  vpc_id = aws_vpc.shibikasri_g_vpc.id

  tags = {
    Name = "Shibikasri_G_IGW"
  }
}
Public Route Table
resource "aws_route_table" "shibikasri_g_public_rt" {
  vpc_id = aws_vpc.shibikasri_g_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shibikasri_g_igw.id
  }

  tags = {
    Name = "Shibikasri_G_Public_RT"
  }
}

resource "aws_route_table_association" "shibikasri_g_public_rt_assoc_1" {
  subnet_id      = aws_subnet.shibikasri_g_public_1.id
  route_table_id = aws_route_table.shibikasri_g_public_rt.id
}

resource "aws_route_table_association" "shibikasri_g_public_rt_assoc_2" {
  subnet_id      = aws_subnet.shibikasri_g_public_2.id
  route_table_id = aws_route_table.shibikasri_g_public_rt.id
}
NAT Gateway + Elastic IP
resource "aws_eip" "shibikasri_g_nat_eip" {
  vpc = true

  tags = {
    Name = "Shibikasri_G_NAT_EIP"
  }
}

resource "aws_nat_gateway" "shibikasri_g_nat_gw" {
  allocation_id = aws_eip.shibikasri_g_nat_eip.id
  subnet_id     = aws_subnet.shibikasri_g_public_1.id

  tags = {
    Name = "Shibikasri_G_NAT_GW"
  }
}
Private Route Table
resource "aws_route_table" "shibikasri_g_private_rt" {
  vpc_id = aws_vpc.shibikasri_g_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.shibikasri_g_nat_gw.id
  }

  tags = {
    Name = "Shibikasri_G_Private_RT"
  }
}

resource "aws_route_table_association" "shibikasri_g_private_rt_assoc_1" {
  subnet_id      = aws_subnet.shibikasri_g_private_1.id
  route_table_id = aws_route_table.shibikasri_g_private_rt.id
}

resource "aws_route_table_association" "shibikasri_g_private_rt_assoc_2" {
  subnet_id      = aws_subnet.shibikasri_g_private_2.id
  route_table_id = aws_route_table.shibikasri_g_private_rt.id
}

