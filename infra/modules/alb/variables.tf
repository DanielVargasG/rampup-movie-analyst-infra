variable "env_name" { type = string }
variable "vpc_id" { type = string }
variable "private_app_subnet_ids" { type = list(string) }
variable "alb_sg_id" { type = string }
variable "target_instance_id" { type = string }
variable "target_port" { type = number }