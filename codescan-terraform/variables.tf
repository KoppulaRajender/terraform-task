variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
}

variable "rds_identifier" {
  description = "RDS ID"
}

variable "rds_instance_class" {
  description = "RDS instace class"
}

variable "rds_allocated_storage" {
  description = "RDS storage allocation"
}

variable "rds_engine" {
  description = "RDS engine"
}

variable "rds_engine_version" {
  description = "RDS engine version"
}

variable "rds_db_username" {
  description = "RDS root username"
}

variable "rds_db_password" {
  description = "RDS root user password"
  sensitive   = true
}

variable "rds_db_port" {
  description = "RDS db port"
}

variable "rds_publicly_accessible" {
  description = "RDS publicly_accessible"
}

variable "rds_skip_final_snapshot" {
  description = "RDS skip_final_snapshot"
}

variable "rds_storage_encrypted" {
  description = "RDS storae encryption"
}