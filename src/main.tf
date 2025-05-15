module "network" {
  source                  = "./modules/network"
  vpc_cidr                = local.env_config.vpc_cidr
  network_public_subnets  = local.env_config.ec2_public_subnets
  network_private_subnets = local.env_config.rds_private_subnets
  tags                    = local.tags
}

module "datasource" {
  source              = "./modules/data"
  key_rds_db_username = local.env_config.key_rds_db_username
  key_rds_db_password = local.env_config.key_rds_db_password
}

module "rds" {
  source                 = "./modules/rds"
  subnet_ids             = module.network.network_private_subnet_ids
  rds_username           = module.datasource.data_rds_db_username
  rds_password           = module.datasource.data_rds_db_password
  rds_security_group_ids = [module.network.rds_security_group_id]
  depends_on             = [module.network, module.datasource]
}
