resource "aws_db_subnet_group" "rds_subnet_group" {
  description = "Subnet group for RDS"
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
  tags = merge(
    var.tags,
    {
      Name = "rds-subnet-group"
    }
  )
}

resource "aws_db_instance" "rds_instance" {
  identifier            = "mysql"
  engine                = "mysql"
  engine_version        = "8.0.40"
  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  username              = var.rds_username
  password              = var.rds_password
  port                  = 3306
  vpc_security_group_ids = var.rds_security_group_ids
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot   = true
  storage_encrypted = true
  storage_type = "gp3"
  multi_az = false
  backup_retention_period = 7
    tags = merge(
    var.tags,
    {
      Name = "RDS MySQL"
    }
  )
}
