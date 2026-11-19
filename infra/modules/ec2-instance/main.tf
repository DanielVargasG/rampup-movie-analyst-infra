resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile        = var.iam_instance_profile_name

  credit_specification {
    cpu_credits = "standard"
  }

  tags = {
    Name = "${var.env_name}-${var.role_name}"
    Env  = var.env_name
    Role = var.role_name
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
}