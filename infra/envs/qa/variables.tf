variable "my_ip" {
  type    = string
  default = "181.135.237.50/32"
}

variable "api_port" {
  type    = number
  default = 3000
}

variable "key_name" {
  type    = string
  default = "key-pair-ssh"
}

variable "ami_id" {
  type    = string
  default = "ami-0bb93e0b5d3dcc3b5" # AL2023 fijado — evita recrear instancias por una AMI mas nueva
}

variable "allow_bastion_db_access" {
  type    = bool
  default = false
}