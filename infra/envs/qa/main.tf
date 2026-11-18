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

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

module "bastion" {
  source             = "../../modules/bastion"
  env_name           = "qa"
  ami_id             = data.aws_ami.al2023.id
  public_subnet_id   = module.vpc.public_subnet_ids[0]
  sg_id              = module.security_groups.bastion_sg_id
  key_name           = var.key_name
  private_app_rt_id  = module.vpc.private_app_route_table_id
  private_db_rt_id   = module.vpc.private_db_route_table_id
}

module "rds" {
  source                 = "../../modules/rds"
  env_name                = "qa"
  private_db_subnet_ids   = module.vpc.private_db_subnet_ids
  db_sg_id                = module.security_groups.db_sg_id
}