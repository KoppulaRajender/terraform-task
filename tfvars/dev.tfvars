#VPC
vpc_cidr    = "10.0.0.0/16"


#RDS
rds_identifier          = "autorabit"
rds_instance_class      = "db.t3.micro"
rds_allocated_storage   = 5
rds_engine              = "postgres"
rds_engine_version      = "13.1"
rds_db_username         = "edu"
rds_db_password         = "hashicrop"
rds_db_port             = "5432"
rds_publicly_accessible = false
rds_skip_final_snapshot = true
rds_storage_encrypted   = false
