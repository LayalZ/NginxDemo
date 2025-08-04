packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.8"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.2"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

 
variable "ami_prefix" {
  type    = string
  default = "al2023-nginxdemo-ami"
}

variable "owner" {
  type        = string
  description = "Owner"
  default     = "amazon"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = "vpc-05691143d3f6baeef"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
  default     = "subnet-0cbf854040cc73081"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID"
  default     = "sg-004753e3e345442d6"
}

variable "ssh_username" {
  type        = string
  description = "ssh_username"
  default     = "ec2-user"
}

variable "instance_name" {
  type        = string
  description = "instance_name"
  default     = "ec2-user"
}


locals {
  timestamp = timestamp()
}

data "amazon-ami" "al2023" {
  filters = {
    name                = "al2023-ami-*-x86_64*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = [var.owner]
  region      = var.region
}

source "amazon-ebs" "al2023_nginx" {
  region        = var.region
  source_ami    = data.amazon-ami.al2023.id
  instance_type = var.instance_type 
  ssh_username  = var.ssh_username
  ami_name      = "${var.ami_prefix}"
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id

  temporary_key_pair_type = "ed25519"
  associate_public_ip_address = true
  ssh_timeout   = "20m"
  ssh_handshake_attempts = 20

  tags = {
    Name        = "NginxDemo-LinuxPacker-Instance"
    CreatedBy   = "Packer"
    Environment = "Development"
  }

  run_tags = {
    Name        = "NginxDemo-LinuxPacker-Instance"
    CreatedBy   = "Packer"
    Environment = "Development"
  }
}

build {
  name    = "amazon-linux-2023-nginx"
  sources = ["source.amazon-ebs.al2023_nginx"]

  provisioner "ansible" {
    playbook_file = "ansible_project/nginx_main_playbook.yml"
    user          = var.ssh_username
    extra_arguments = [
      "--ssh-extra-args=-o IdentitiesOnly=yes",
      "--scp-extra-args=-O"
    ]
  }


}