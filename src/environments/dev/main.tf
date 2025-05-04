module "network" {
  source              = "../../modules/network"
  vpc_cidr            = var.vpc_cidr
  ec2_public_subnets  = var.ec2_public_subnets
  rds_private_subnets = var.rds_private_subnets
  tags                = local.tags
}
