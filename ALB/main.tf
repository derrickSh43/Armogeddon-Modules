// Application Load Balancer
resource "aws_lb" "alb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.default_sg ? [aws_security_group.default_sg[0].id] : var.security_group_ids
  subnets            = var.subnet_ids
  enable_deletion_protection = false

  tags = var.tags
}

// Target group
resource "aws_lb_target_group" "tg" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = var.tags
}
resource "aws_lb_listener" "http" {
  count             = var.listener_http ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "https" {
  count             = var.listener_https ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

// Security groups
resource "aws_security_group" "default_sg" {
  count       = var.default_sg ? 1 : 0
  name        = "${var.name}-default-sg"
  description = "Default security group for ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-default-sg"
  }
}

# Ingress Rules
resource "aws_security_group_rule" "default_sg_ingress" {
  count = var.default_sg ? length(var.default_sg_ingress_rules) : 0

  type                     = "ingress"
  security_group_id        = aws_security_group.default_sg[0].id
  from_port                = var.default_sg_ingress_rules[count.index].from_port
  to_port                  = var.default_sg_ingress_rules[count.index].to_port
  protocol                 = var.default_sg_ingress_rules[count.index].protocol
  cidr_blocks              = var.default_sg_ingress_rules[count.index].cidr_blocks
  description              = var.default_sg_ingress_rules[count.index].description
}

# Egress Rules
resource "aws_security_group_rule" "default_sg_egress" {
  count = var.default_sg ? length(var.default_sg_egress_rules) : 0

  type                     = "egress"
  security_group_id        = aws_security_group.default_sg[0].id
  from_port                = var.default_sg_egress_rules[count.index].from_port
  to_port                  = var.default_sg_egress_rules[count.index].to_port
  protocol                 = var.default_sg_egress_rules[count.index].protocol
  cidr_blocks              = var.default_sg_egress_rules[count.index].cidr_blocks
  description              = var.default_sg_egress_rules[count.index].description
}

