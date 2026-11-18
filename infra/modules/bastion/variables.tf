variable "env_name" {
  type = string
}

variable "ami_id" {
  type        = string
  description = "AMI de Amazon Linux 2023 para la región - ver nota abajo sobre cómo obtenerla"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "public_subnet_id" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "key_name" {
  type        = string
  description = "Nombre del key pair EC2 ya creado en la consola (Fase 0 lo da por hecho, pero verifica que exista)"
}

variable "private_app_rt_id" {
  type = string
}

variable "private_db_rt_id" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}