resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile_name

  # Desactivar source/dest check — imprescindible para que funcione como NAT
  source_dest_check = false

  credit_specification {
    cpu_credits = "standard"
  }

  user_data = file("${path.module}/user_data.sh.tpl")

  tags = {
    Name = "${var.env_name}-bastion-nat"
    Env  = var.env_name
  }
}

# Ruta de salida para las subredes privadas-app, a través del bastion/NAT
resource "aws_route" "private_app_nat" {
  route_table_id         = var.private_app_rt_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.bastion.primary_network_interface_id
}

resource "aws_route" "private_db_nat" {
  route_table_id         = var.private_db_rt_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.bastion.primary_network_interface_id
}