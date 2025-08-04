variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1" 
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
  default     = "ami-08a6efd148b1f7504"
}

variable "project_name" {
  description = "A name for the project to be used in resource naming and tags."
  type        = string
  default     = "NginxDemo"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  type        = number
  default     = 2 # At least 2 for redundancy across 2 AZs
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "my_public_ip" {
  description = "My local public IP address for SSH access to the Ansible control node. Set it occasionally to 0.0.0.0 since my IP keeps changing."
  type        = string
  default     = "0.0.0.0/0" # WARNING: Restrict this to your actual public IP in production!
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for HTTPS listener on ALB."
  type        = string
  default     = "arn:aws:acm:us-east-1:292235351794:certificate/28cf8d11-1bd5-4855-8a5a-4d01423d5da6"
}
 
