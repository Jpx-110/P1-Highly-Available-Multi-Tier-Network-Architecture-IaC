#1. PROVIDER: Connects to nearest AWS region
provider "aws" {
  region = "eu-west-2"
}

#2. RESOURCE: Creare a VPC with CIDR Block - this is the network perimter for our infrastructure
resource "aws_vpc" "main_vpc" {
    cidr_block              = "10.0.0.0/16"
    enable_dns_hostnames    = true
    tags = { Name = "P1-Highly Available Multi Tier Network Architecture" } 
}

#3.RESOURCE > Subnets > Public(Internet facing) and Private(secure) subnets
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags = { Name = "Public Subnet" }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = { Name = "Private-Subnet" }
}

# 4. INTERNET GATEWAY: The entry point
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# 5. ROUTE TABLE: Rules to send public traffic to the Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}