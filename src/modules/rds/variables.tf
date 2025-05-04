variable "subnet_ids" {
  description = "Lista de IDs de subnets para o grupo de subnet do RDS"
  type        = list(string)
}

variable "tags" {
  description = "Tags a serem aplicadas aos recursos"
  type        = map(string)
  default     = {}
}

variable "rds_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Quantidade de armazenamento alocado para o RDS em GB"
  type        = number
  default     = 20
}

variable "rds_username" {
  description = "Nome de usuário para o administrador do RDS"
  type        = string
}

variable "rds_password" {
  description = "Senha para o administrador do RDS"
  type        = string
  sensitive   = true
}

variable "rds_security_group_ids" {
  description = "IDs do security group do RDS"
  type        = list(string)
}
