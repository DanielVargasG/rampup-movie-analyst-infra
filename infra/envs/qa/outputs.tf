output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_app_subnet_ids" {
  value = module.vpc.private_app_subnet_ids
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "front_public_ip" { 
  value = module.front_ec2.instance_id
}

output "alb_dns_name"{
  value = module.alb.alb_dns_name 
}