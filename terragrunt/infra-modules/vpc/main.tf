# ---------------------------------------------------------------------------------------------------------------------
# A SIMPLE EXAMPLE OF HOW TO DEPLOY MYSQL ON RDS
# This is an example of how to use Terraform to deploy a MySQL database on Amazon RDS.
#
# Note: This code is meant solely as a simple demonstration of how to lay out your files and folders with Terragrunt
# in a way that keeps your Terraform code DRY. This is not production-ready code, so use at your own risk.
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # Live modules pin exact Terraform version; generic modules let consumers pin the version.
  # The latest version of Terragrunt (v0.29.0 and above) recommends Terraform 0.15.0 or above.
  required_version = "= 0.15.0"

  # Live modules pin exact provider version; generic modules let consumers pin the version.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.7.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "vpc_main" {
    cidr_block       = var.cidr_block
    instance_tenancy = "default"
    tags = {
        Name = "vpc_main"
    }
}

resource "aws_subnet" "public_subnet" {
    depends_on = [
        aws_vpc.vpc_main
    ]
    
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = var.cidr_block_public_subnet
    
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    depends_on = [
        aws_vpc.vpc_main,
        aws_subnet.public_subnet
    ]
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = var.cidr_block_private_subnet
    
    tags = {
        Name = "private_subnet"
    }
}

# Creating an Internet Gateway for the VPC
resource "aws_internet_gateway" "internet_gateway" {
    depends_on = [
    aws_vpc.vpc_main,
    aws_subnet.public_subnet,
    aws_subnet.private_subnet
    ]

# VPC in which it has to be created!
    vpc_id = aws_vpc.vpc_main.id

    tags = {
    Name = "ig-vpc"
    }
}
# Creating an Route Table for the public subnet!
resource "aws_route_table" "public_subnet_rt" {
  depends_on = [
    aws_vpc.vpc_main,
    aws_internet_gateway.internet_gateway
  ]

  # VPC ID
  vpc_id = aws_vpc.vpc_main.id

  # NAT Rule
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public_subnet_rt"
  }
}
# Creating a resource for the Route Table Association!
resource "aws_route_table_association" "rt_ig_Association" {

  depends_on = [
    aws_vpc.vpc_main,
    aws_subnet.public_subnet,
    aws_subnet.private_subnet,
    aws_route_table.public_subnet_rt
  ]

  # Public Subnet ID
  subnet_id = aws_subnet.public_subnet.id

  #  Route Table ID
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_security_group" "rds_sg" {
    name   = "rds_sg"
    vpc_id = aws_vpc.vpc_main.id

    ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
    Name = "rds_sg"
    }
}