variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Região da AWS para provisionamento dos recursos"
}

variable "vpc_cidr" {
  description = "CIDR do VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "ec2_public_subnets" {
  description = "Subnets públicas para provisionamento dos recursos da EC2"
  type        = list(string)
  default     = ["172.31.1.0/24", "172.31.2.0/24"]
}

variable "rds_private_subnets" {
  description = "Subnets privadas para provisionamento dos recursos do RDS"
  type        = list(string)
  default     = ["172.31.101.0/24", "172.31.102.0/24"]
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "infrastructure"
    ManagedBy   = "terraform"
    Owner       = "devops-iac-team"
  }
}