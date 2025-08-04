locals {
  # Common tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  # Variable names for all resources
  vpc_name               = "${var.project_name}-VPC"
  igw_name               = "${var.project_name}-IGW"
  public_rt_name         = "${var.project_name}-PublicRT"
  private_rt_name        = "${var.project_name}-PrivateRT"
  nat_eip_name           = "${var.project_name}-NATEIP"
  nat_gateway_name       = "${var.project_name}-NATGateway"
  alb_sg_name            = "${var.project_name}-ALBSG"
  ec2_sg_name            = "${var.project_name}-EC2SG"
  ansible_control_sg_name = "${var.project_name}-AnsibleControlSG" 
  ansible_control_node_name = "${var.project_name}-AnsibleControlNode" 
  ec2_role_name          = "${var.project_name}-EC2Role"
  ec2_profile_name       = "${var.project_name}-EC2Profile"
  ansible_role_name      = "${var.project_name}-AnsibleRole"
  ansible_profile_name   = "${var.project_name}-AnsibleProfile"
  ansible_policy_name    = "${var.project_name}-AnsiblePolicy"
  ssh_key_pair_name      = "${var.project_name}-Key" 
  launch_template_name   = "${var.project_name}-LaunchTemplate"
  autoscaling_group_name = "${var.project_name}-ASG"
  alb_name               = "${var.project_name}-ALB"
  alb_target_group_name  = "${var.project_name}-NginxTG"
  alb_http_listener_name = "${var.project_name}-HTTPListener"
  ec2_instance_name      = "${var.project_name}-NginxServer" 

  # Configurations for public and private subnets
  public_subnets_config = {
    "public_subnet_1" = {
      cidr_block = "10.0.1.0/24"
      az_suffix  = "a"
    },
    "public_subnet_2" = {
      cidr_block = "10.0.2.0/24"
      az_suffix  = "b"
    }
  }

  private_subnets_config = {
    "private_subnet_1" = {
      cidr_block = "10.0.10.0/24"
      az_suffix  = "a"
    },
    "private_subnet_2" = {
      cidr_block = "10.0.11.0/24"
      az_suffix  = "b"
    }
  }
}