resource "aws_lb" "this" {
  name               = "${var.env_name}-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_app_subnet_ids
  security_groups    = [var.alb_sg_id]

  tags = { Name = "${var.env_name}-alb", Env = var.env_name }
}

resource "aws_lb_target_group" "backend" {
  name     = "${var.env_name}-tg-backend"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = { Name = "${var.env_name}-tg-backend", Env = var.env_name }
}

resource "aws_lb_target_group_attachment" "backend" {
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = var.target_instance_id
  port             = var.target_port
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}