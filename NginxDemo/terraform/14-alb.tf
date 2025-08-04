resource "aws_lb" "nginx_alb" {
  name               = local.alb_name
  internal           = false # Public-facing ALB
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnets["public_subnet_1"].id, aws_subnet.public_subnets["public_subnet_2"].id]

  enable_deletion_protection = false # Set to true in production

  tags = merge(local.common_tags, {
    Name = local.alb_name
  })
}

# ALB Target Group 
resource "aws_lb_target_group" "nginx_tg" {
  name     = local.alb_target_group_name
  port     = 443 
  protocol = "HTTPS" 
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTPS" # Health checks over HTTPS
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, {
    Name = local.alb_target_group_name
  })
}

# ALB Listener - Redirecting HTTP to HTTPS
resource "aws_lb_listener" "nginx_http_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301" # Permanent redirect
    }
  }

  tags = merge(local.common_tags, {
    Name = local.alb_http_listener_name
  })
}

# ALB Listener for HTTPS (port 443) - Forwards to Nginx on HTTPS
resource "aws_lb_listener" "nginx_https_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn # Reference the ACM certificate ARN
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" # Recommended modern SSL policy

  default_action {
    target_group_arn = aws_lb_target_group.nginx_tg.arn # "arn:aws:elasticloadbalancing:us-east-1:292235351794:targetgroup/NginxApp-NginxTG/1c808122faeb3920" #  
    type             = "forward"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-HTTPSListener"
  })
}
