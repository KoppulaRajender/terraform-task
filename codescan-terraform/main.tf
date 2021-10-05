provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "koppula-terraform-state"
    key    = "s3/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "autorabit"
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "autorabit" {
  name       = "autorabit"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "AutoRabit"
  }
}

resource "aws_security_group" "rds" {
  name   = "autorabit_rds"
  vpc_id = module.vpc.vpc_id

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
    Name = "autorabit_rds"
  }
}

resource "aws_db_parameter_group" "autorabit" {
  name   = "autorabit"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "autorabit" {
  identifier             = var.rds_identifier
  instance_class          = var.rds_instance_class
  allocated_storage       = var.rds_allocated_storage
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  username               = var.rds_db_username
  password               = var.rds_db_password
  port                    = var.rds_db_port
  db_subnet_group_name   = aws_db_subnet_group.autorabit.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.autorabit.name
  publicly_accessible    = var.rds_publicly_accessible
  skip_final_snapshot    = var.rds_skip_final_snapshot
  storage_encrypted       = var.rds_storage_encrypted
}
