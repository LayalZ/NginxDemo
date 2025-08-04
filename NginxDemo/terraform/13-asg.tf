resource "aws_launch_template" "nginx_lt" {
  name_prefix   = "${local.launch_template_name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${local.ec2_instance_name}-ASG-Instance"
    })
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(local.common_tags, {
      Name = "${local.ec2_instance_name}-ASG-Volume"
    })
  }


  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = local.launch_template_name
  })
}

# Auto Scaling Group
resource "aws_autoscaling_group" "nginx_asg" {
  name                      = local.autoscaling_group_name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = [
    aws_subnet.private_subnets["private_subnet_1"].id,
    aws_subnet.private_subnets["private_subnet_2"].id
  ]
  target_group_arns         = [aws_lb_target_group.nginx_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300   

  launch_template {
    id      = aws_launch_template.nginx_lt.id
    version = "$Latest" 
  }

  # Tags to be assigned to instances launched by the ASG
  tag {
    key                 = "Name"
    value               = "${local.ec2_instance_name}-ASG-Instance"
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  # Tags for the Auto Scaling Group resource
  tag {
    key                 = "Name"
    value               = local.autoscaling_group_name
    propagate_at_launch = false 
  }
  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = false 
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EC2 Instance for Ansible Control Node
resource "aws_instance" "ansible_control_node" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name # Use the same key pair
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id # Place in a public subnet for SSH access from your IP
  vpc_security_group_ids = [aws_security_group.ansible_control_sg.id]
  associate_public_ip_address = true # Assign a public IP for direct SSH from your laptop
  iam_instance_profile = aws_iam_instance_profile.ansible_control_profile.name

  tags = merge(local.common_tags, {
    Name = local.ansible_control_node_name
  })
}