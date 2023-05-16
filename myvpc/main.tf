provider "aws" {
  region = "us-east-2"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}


# Resource configuration blocks
resource "aws_vpc" "example_vpc" {
  cidr_block = var.vpc_cidr_block # replace with the desired VPC CIDR block
}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = var.subnet_cidr_block # replace with the desired subnet CIDR block
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}

resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

resource "aws_security_group" "my_sg" {
  name_prefix = "my_sg_"
  description = "My security group"
  vpc_id = aws_vpc.example_vpc.id
  ingress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "all"
    cidr_blocks = ["71.78.23.147/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_vpc.example_vpc]
}
