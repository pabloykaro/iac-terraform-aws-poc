locals {
  env = terraform.workspace == "default" ? "development" : terraform.workspace

  environment_configs = {
    development = {
      vpc_cidr            = "172.31.0.0/16"
      ec2_public_subnets  = ["172.31.1.0/24", "172.31.2.0/24"]
      rds_private_subnets = ["172.31.101.0/24", "172.31.102.0/24"]
      rds_instance_class  = "db.t3.micro"
      rds_storage         = 20
      key_rds_db_username = "dev_rds_username"
      key_rds_db_password = "dev_rds_password"
      tags = {
        Environment = "development"
      }
    }
    staging = {
      vpc_cidr            = "172.32.0.0/16"
      ec2_public_subnets  = ["172.32.1.0/24", "172.32.2.0/24"]
      rds_private_subnets = ["172.32.101.0/24", "172.32.102.0/24"]
      rds_instance_class  = "db.t3.small"
      rds_storage         = 50
      key_rds_db_username = "staging_rds_username"
      key_rds_db_password = "staging_rds_password"
      tags = {
        Environment = "staging"
      }
    }
    production = {
      vpc_cidr            = "172.33.0.0/16"
      ec2_public_subnets  = ["172.33.1.0/24", "172.33.2.0/24"]
      rds_private_subnets = ["172.33.101.0/24", "172.33.102.0/24"]
      rds_instance_class  = "db.t3.medium"
      rds_storage         = 100
      key_rds_db_username = "production_rds_username"
      key_rds_db_password = "production_rds_password"
      tags = {
        Environment = "production"
      }
    }
  }

  env_config = local.environment_configs[local.env]

  tags = merge(
    var.tags,
    {
      Environment = "development"
    }
  )
}