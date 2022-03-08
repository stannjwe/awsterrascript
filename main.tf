provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}
variable "region" {}
variable "secret_key" {}
variable "access_key" {}
variable "vpc_cidr" {}
variable "subnet_cidr" {}
variable "route_cidr" {}
variable "availability_zone" {}
variable "security_cidr" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}



resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "mysubnet"
  }
}
resource "aws_internet_gateway" "mygateway" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "mygateway"
  }
}
resource "aws_route" "myroute" {
  route_table_id = aws_vpc.myvpc.id
  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.mygateway.id
  }
  tags = {
    Name = "myroute"
  }
}
resource "aws_security_group" "mysecurity" {
  name = "mysecurity"
  vpc_id = aws_vpc.myvpc.id
  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = var.security_cidr
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = var.security_cidr
  }
}
resource "aws_instance" "myinstance" {
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  subnet_id = aws_subnet.mysubnet.id
  vpc_security_group_ids = [aws_security_group]
  associate_public_ip_address = true
  key_name = var.key_name
}