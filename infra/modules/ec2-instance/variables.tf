variable "env_name" {
  type = string
}

variable "role_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "associate_public_ip" {
  type    = bool
  default = false
}

variable "iam_instance_profile_name" {
  type    = string
  default = null
}