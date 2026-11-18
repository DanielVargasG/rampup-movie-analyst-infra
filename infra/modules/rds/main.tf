resource "random_password" "db_master" {
  length           = 20
  special          = true
  override_special = "!#%^*()-_=+[]{}<>?"
  # Excluye '/', '@', '"' y espacio — caracteres no permitidos por RDS en la contraseña
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.env_name}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = { Name = "${var.env_name}-db-subnet-group", Env = var.env_name }
}

resource "aws_db_parameter_group" "mysql84" {
  name   = "${var.env_name}-mysql84-pg"
  family = "mysql8.4"

  tags = { Name = "${var.env_name}-mysql84-pg", Env = var.env_name }
}

resource "aws_db_instance" "this" {
  identifier     = "${var.env_name}-movie-db"
  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.master_username
  password = random_password.db_master.result

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]
  parameter_group_name   = aws_db_parameter_group.mysql84.name

  publicly_accessible = false
  multi_az             = var.multi_az

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = false

  # Evita la inscripción automática en Extended Support (de pago)
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"

  tags = { Name = "${var.env_name}-movie-db", Env = var.env_name }
}