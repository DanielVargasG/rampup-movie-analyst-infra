variable "env_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "my_ip" {
  type        = string
  description = "IP pública con /32"
}

variable "api_port" {
  type    = number
  default = 3000
}

variable "allow_bastion_db_access" {
  type        = bool
  default     = true
  description = "Temporal: permite al bastion llegar a RDS:3306 para pruebas de conexión"
}