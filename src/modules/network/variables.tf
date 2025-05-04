variable "vpc_cidr" {
  type = string
}

variable "network_public_subnets" {
  type = list(string)
}

variable "network_private_subnets" {
  type = list(string)
}

variable "availability_zones" {
  description = "Zonas de disponibilidade para as subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  description = "Tags padrão para todos os recursos"
  type        = map(string)
}

