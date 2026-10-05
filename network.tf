module "vpc" {
  source = "./modules/vpc"

  vpc_network            = var.vpc_network
  vpc_subnet             = var.vpc_subnet
  gateway                = var.gateway
  route_table            = var.route_table
  security_group         = var.security_group
  security_group_ingress = var.security_group_ingress
  security_group_egress  = var.security_group_egress
}