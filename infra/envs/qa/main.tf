provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source   = "../../modules/vpc"
  env_name = "qa"
  vpc_cidr = "10.10.0.0/16"
  azs      = ["us-east-2a", "us-east-2b"]
}

module "security_groups" {
  source   = "../../modules/security-groups"
  env_name = "qa"
  vpc_id   = module.vpc.vpc_id
  my_ip    = var.my_ip
  api_port = var.api_port
}