output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.autorabit.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.autorabit.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.autorabit.username
  sensitive   = true
}

output "publicly_accessible" {
  description = "RDS instance publicly_accessible"
  value       = aws_db_instance.autorabit.publicly_accessible
}