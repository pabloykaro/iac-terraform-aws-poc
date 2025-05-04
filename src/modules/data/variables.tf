variable "key_rds_db_username" {
  description = "Chave do SSM Parameter Store para o nome de usuário do banco de dados"
  type        = string
}

variable "key_rds_db_password" {
  description = "Chave do SSM Parameter Store para a senha do banco de dados"
  type        = string
}