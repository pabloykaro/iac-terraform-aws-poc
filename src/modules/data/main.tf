data "aws_ssm_parameter" "rds_db_username" {
  name = var.key_rds_db_username
}

data "aws_ssm_parameter" "rds_db_password" {
  name = var.key_rds_db_password
}