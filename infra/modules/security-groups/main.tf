# --- Los 5 security groups (vacíos, las reglas van aparte) ---
resource "aws_security_group" "bastion" {
  name   = "${var.env_name}-sg-bastion"
  vpc_id = var.vpc_id
  tags   = { Name = "${var.env_name}-sg-bastion", Env = var.env_name }
}

resource "aws_security_group" "front" {
  name   = "${var.env_name}-sg-front"
  vpc_id = var.vpc_id
  tags   = { Name = "${var.env_name}-sg-front", Env = var.env_name }
}

resource "aws_security_group" "alb" {
  name   = "${var.env_name}-sg-alb"
  vpc_id = var.vpc_id
  tags   = { Name = "${var.env_name}-sg-alb", Env = var.env_name }
}

resource "aws_security_group" "back" {
  name   = "${var.env_name}-sg-back"
  vpc_id = var.vpc_id
  tags   = { Name = "${var.env_name}-sg-back", Env = var.env_name }
}

resource "aws_security_group" "db" {
  name   = "${var.env_name}-sg-db"
  vpc_id = var.vpc_id
  egress = [] # RDS no necesita salir a ningún lado — sin esto, AWS deja "allow all" por defecto
  tags   = { Name = "${var.env_name}-sg-db", Env = var.env_name }
}

# ===================== sg-bastion =====================
resource "aws_security_group_rule" "bastion_ingress_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  description       = "SSH desde la IP del operador"
}

resource "aws_security_group_rule" "bastion_ingress_nat_http" {
  type                     = "ingress"
  security_group_id        = aws_security_group.bastion.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.back.id
  description              = "Funcion NAT: HTTP saliente del backend"
}

resource "aws_security_group_rule" "bastion_ingress_nat_https" {
  type                     = "ingress"
  security_group_id        = aws_security_group.bastion.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.back.id
  description              = "Funcion NAT: HTTPS saliente del backend"
}

resource "aws_security_group_rule" "bastion_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.bastion.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ===================== sg-front =====================
resource "aws_security_group_rule" "front_ingress_http" {
  type              = "ingress"
  security_group_id = aws_security_group.front.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "front_ingress_https" {
  type              = "ingress"
  security_group_id = aws_security_group.front.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "front_ingress_ssh" {
  type                     = "ingress"
  security_group_id        = aws_security_group.front.id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "front_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.front.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ===================== sg-alb =====================
resource "aws_security_group_rule" "alb_ingress_http" {
  type                     = "ingress"
  security_group_id        = aws_security_group.alb.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.front.id
}

resource "aws_security_group_rule" "alb_egress_to_back" {
  type                     = "egress"
  security_group_id        = aws_security_group.alb.id
  from_port                = var.api_port
  to_port                  = var.api_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.back.id
}

# ===================== sg-back =====================
resource "aws_security_group_rule" "back_ingress_api" {
  type                     = "ingress"
  security_group_id        = aws_security_group.back.id
  from_port                = var.api_port
  to_port                  = var.api_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "back_ingress_ssh" {
  type                     = "ingress"
  security_group_id        = aws_security_group.back.id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "back_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.back.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ===================== sg-db =====================
resource "aws_security_group_rule" "db_ingress_from_back" {
  type                     = "ingress"
  security_group_id        = aws_security_group.db.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.back.id
}

resource "aws_security_group_rule" "db_ingress_from_bastion" {
  count                    = var.allow_bastion_db_access ? 1 : 0
  type                     = "ingress"
  security_group_id        = aws_security_group.db.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  description              = "Temporal - solo para la migracion de esquema/datos"
}