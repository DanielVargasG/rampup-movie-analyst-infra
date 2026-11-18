variable "env_name" {
  type = string
}

variable "private_db_subnet_ids" {
  type = list(string)
}

variable "db_sg_id" {
  type = string
}

variable "engine_version" {
  type    = string
  default = "8.4"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "movie_db"
}

variable "master_username" {
  type    = string
  default = "admin"
}

variable "backup_retention_period" {
  type    = number
  default = 1
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "multi_az" {
  type    = bool
  default = false
}