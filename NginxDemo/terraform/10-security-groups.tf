resource "aws_security_group" "alb_sg" {
  name        = local.alb_sg_name
  description = "Allow HTTP and HTTPS traffic to ALB for ${var.project_name}"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = local.alb_sg_name
  })
}


resource "aws_security_group" "ansible_control_sg" {
  name        = local.ansible_control_sg_name
  description = "Allow SSH from my IP to Ansible Control Node & outbound to private instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip] # Allow SSH from your public IP
    description = "Allow SSH from my public IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all other outbound traffic"
  }

  tags = merge(local.common_tags, {
    Name = local.ansible_control_sg_name
  })
}

# Security Group for the EC2 instances in the Auto Scaling Group
resource "aws_security_group" "ec2_sg" {
  name        = local.ec2_sg_name
  description = "Allow HTTP/HTTPS from ALB and SSH from Ansible Control Node for ${var.project_name} EC2" # Updated description
  vpc_id      = aws_vpc.main.id

  # Ingress rule for HTTP (port 80) from ALB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description = "Allow HTTP from ALB"
  }

  # Ingress rule for HTTPS from ALB
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description = "Allow HTTPS from ALB"
  }

  # Egress rule (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = local.ec2_sg_name
    Project     = local.common_tags.Project
    Environment = local.common_tags.Environment
    ManagedBy   = local.common_tags.ManagedBy
  }
}

# Ingress rule for SSH from Ansible Control Node to EC2 instances
resource "aws_security_group_rule" "ansible_to_ec2_ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ansible_control_sg.id
  security_group_id        = aws_security_group.ec2_sg.id
  description              = "Allow SSH from Ansible Control Node to Nginx ASG instances"
}

# Ingress rule for SSH from Ansible Control Node to ALB 
resource "aws_security_group_rule" "ansible_to_alb_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ansible_control_sg.id
  security_group_id        = aws_security_group.alb_sg.id
  description              = "Allow SSH from Ansible Control Node to ALB"
}