output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_app_subnet_ids" {
  value = module.vpc.private_app_subnet_ids
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}