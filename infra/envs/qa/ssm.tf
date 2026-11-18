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

resource "random_password" "db_app" {
  length           = 20
  special          = true
  override_special = "!#%^*()-_=+[]{}<>?"
}

resource "aws_ssm_parameter" "db_app_username" {
  name  = "/rampup/qa/db/app_username"
  type  = "String"
  value = "applicationuser"
}

resource "aws_ssm_parameter" "db_app_password" {
  name   = "/rampup/qa/db/app_password"
  type   = "SecureString"
  key_id = "alias/aws/ssm"
  value  = random_password.db_app.result
}