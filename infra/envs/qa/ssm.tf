resource "aws_ssm_parameter" "db_host" {
  name  = "/rampup/qa/db/host"
  type  = "String"
  value = module.rds.db_endpoint
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/rampup/qa/db/port"
  type  = "String"
  value = tostring(module.rds.db_port)
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/rampup/qa/db/name"
  type  = "String"
  value = module.rds.db_name
}

resource "aws_ssm_parameter" "db_master_username" {
  name  = "/rampup/qa/db/master_username"
  type  = "String"
  value = module.rds.master_username
}

resource "aws_ssm_parameter" "db_master_password" {
  name   = "/rampup/qa/db/master_password"
  type   = "SecureString"
  key_id = "alias/aws/ssm"
  value  = module.rds.db_master_password
}