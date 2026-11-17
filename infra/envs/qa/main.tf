provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source   = "../../modules/vpc"
  env_name = "qa"
  vpc_cidr = "10.10.0.0/16"
  azs      = ["us-east-2a", "us-east-2b"]
}