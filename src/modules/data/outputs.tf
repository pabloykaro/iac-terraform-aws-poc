output "data_rds_db_username" {
  description = "Nome de usuário do banco de dados"
  value       = data.aws_ssm_parameter.rds_db_username.value
}

output "data_rds_db_password" {
  description = "Senha do banco de dados"
  value       = data.aws_ssm_parameter.rds_db_password.value
}
