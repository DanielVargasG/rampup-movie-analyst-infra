variable "env_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string) # ["us-east-2a", "us-east-2b"]
}