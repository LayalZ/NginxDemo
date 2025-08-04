output "alb_dns_name" {
  description = "The DNS name of the Nginx Application Load Balancer"
  value       = aws_lb.nginx_alb.dns_name
}

# Output the public IP address of the NAT Gateway (for reference, not direct access)
output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

# Output the generated private key for SSH access
output "private_key" {
  description = "The private key for SSH access to the EC2 instance. Save this securely!"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true # Mark as sensitive to prevent it from being displayed in plaintext in logs
}

# --- Additional Outputs for each step ---

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = [for s in aws_subnet.public_subnets : s.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = [for s in aws_subnet.private_subnets : s.id]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.gw.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.main.id
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "The ID of the private route table."
  value       = aws_route_table.private_rt.id
}

output "alb_security_group_id" {
  description = "The ID of the ALB Security Group."
  value       = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 Security Group for ASG instances."
  value       = aws_security_group.ec2_sg.id
}

output "ansible_control_sg_id" { # New output for the control node SG
  description = "The ID of the Ansible Control Node Security Group."
  value       = aws_security_group.ansible_control_sg.id
}

output "ansible_control_node_public_ip" { # New output for Ansible control node public IP
  description = "The public IP address of the Ansible Control Node EC2 instance."
  value       = aws_instance.ansible_control_node.public_ip
}

output "ec2_iam_role_arn" {
  description = "The ARN of the IAM Role for Nginx ASG EC2 instances."
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_arn" {
  description = "The ARN of the IAM Instance Profile for Nginx ASG EC2 instances."
  value       = aws_iam_instance_profile.ec2_profile.arn
}

output "ansible_control_role_arn" { # New output for Ansible control node IAM role ARN
  description = "The ARN of the IAM Role for the Ansible Control Node EC2 instance."
  value       = aws_iam_role.ansible_control_role.arn
}

output "ansible_control_profile_arn" { # New output for Ansible control node IAM instance profile ARN
  description = "The ARN of the IAM Instance Profile for the Ansible Control Node EC2 instance."
  value       = aws_iam_instance_profile.ansible_control_profile.arn
}

output "ssh_key_pair_id" {
  description = "The ID of the generated SSH Key Pair."
  value       = aws_key_pair.generated_key.id
}

output "launch_template_id" {
  description = "The ID of the EC2 Launch Template."
  value       = aws_launch_template.nginx_lt.id
}

output "autoscaling_group_name_output" {
  description = "The name of the Auto Scaling Group."
  value       = aws_autoscaling_group.nginx_asg.name
}

output "alb_target_group_arn" {
  description = "The ARN of the ALB Target Group."
  value       = aws_lb_target_group.nginx_tg.arn
}

output "alb_http_listener_arn" {
  description = "The ARN of the ALB HTTP Listener."
  value       = aws_lb_listener.nginx_http_listener.arn
}
