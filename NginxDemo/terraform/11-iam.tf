# IAM Policy for Ansible Control Node to describe EC2 instances for dynamic inventory
resource "aws_iam_policy" "ansible_inventory_policy" {
  name        = local.ansible_policy_name
  description = "Allows Ansible control node to describe EC2 instances for dynamic inventory."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeTags",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceStatus",
          "ec2:CreateKeyPair",
          "ec2:CreateTags",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StopInstances",
          "ec2:CreateImage",
          "ec2:DescribeVolumes",
          "ec2:DeregisterImage",
          "ec2:DeleteKeyPair"
        ],
        Resource = "*"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = local.ansible_policy_name
  })
}

# IAM Role for Ansible Control Node EC2 instance
resource "aws_iam_role" "ansible_control_role" {
  name = local.ansible_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.common_tags, {
    Name = local.ansible_role_name
  })
}

# Attach Ansible Inventory Policy to the Ansible Control Node Role
resource "aws_iam_role_policy_attachment" "ansible_inventory_attachment" {
  role       = aws_iam_role.ansible_control_role.name
  policy_arn = aws_iam_policy.ansible_inventory_policy.arn
}

# Attach SSM Managed Instance Core policy to the Ansible Control Node Role (for Session Manager access)
resource "aws_iam_role_policy_attachment" "ansible_ssm_attachment" {
  role       = aws_iam_role.ansible_control_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile for Ansible Control Node
resource "aws_iam_instance_profile" "ansible_control_profile" {
  name = local.ansible_profile_name
  role = aws_iam_role.ansible_control_role.name
}

# IAM Role for Nginx ASG EC2 instance (for reasonable permissions)
resource "aws_iam_role" "ec2_role" {
  name = local.ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.common_tags, {
    Name = local.ec2_role_name
  })
}

# Attach SSM Managed Instance Core policy to the Nginx ASG Role (for Session Manager access)
resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # Allows SSM access
}

# IAM Instance Profile to attach the Nginx ASG role to the EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = local.ec2_profile_name
  role = aws_iam_role.ec2_role.name
}