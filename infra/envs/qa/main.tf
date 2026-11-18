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
  iam_instance_profile_name = aws_iam_instance_profile.bastion.name
}

module "rds" {
  source                 = "../../modules/rds"
  env_name                = "qa"
  private_db_subnet_ids   = module.vpc.private_db_subnet_ids
  db_sg_id                = module.security_groups.db_sg_id
}

module "backend_ec2" {
  source               = "../../modules/ec2-instance"
  env_name             = "qa"
  role_name            = "backend"
  ami_id               = data.aws_ami.al2023.id
  subnet_id            = module.vpc.private_app_subnet_ids[0]
  sg_id                = module.security_groups.back_sg_id
  key_name             = var.key_name
  associate_public_ip  = false
  iam_instance_profile_name = aws_iam_instance_profile.backend.name
}

module "front_ec2" {
  source              = "../../modules/ec2-instance"
  env_name            = "qa"
  role_name           = "front"
  ami_id              = data.aws_ami.al2023.id
  subnet_id           = module.vpc.public_subnet_ids[0]
  sg_id               = module.security_groups.front_sg_id
  key_name            = var.key_name
  associate_public_ip = true
}

module "alb" {
  source                 = "../../modules/alb"
  env_name               = "qa"
  vpc_id                 = module.vpc.vpc_id
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  alb_sg_id              = module.security_groups.alb_sg_id
  target_instance_id     = module.backend_ec2.instance_id
  target_port            = var.api_port
}