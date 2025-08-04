# NginxDemo


# NginxDemo Architecture

The NginxDemo creates the infrastructure shown in the architecture below using terraform. 

<img width="581" height="496" alt="Untitled Diagram drawio" src="https://github.com/user-attachments/assets/e9158b31-df8d-4eb6-835a-d2127abcef05" />


To note that only one NAT gateway is created in the demo. However, to avoid any single point of failure, having another NAT gateway in a differenet availability zone is recommended.

# PART 1: Terraform

The terraform scripts consists of creating the following infrastructure:
- VPC
- Two Public Subnets - each in different Availability Zone in us-east-1
- Two Private Subnets - each in different Availabiltiy Zone in us-east-1
- Internet Gateway
- NAT Gateway in Public Subnet 1 - created only 1 but it's recommended to have 2 instead
- Private Route Table to allow outbound internet access through NAT gateway
- Application Load Balancer
- Auto Scaling Groug (min: 2 - max:4 EC2 instances)
- Nginx EC2 instances controlled by Auto Scaling Group
- Ansible Control Node EC2
- IAM roles and permissions
- Security Groups:
  * Allow HTTP and HTTPS traffic to ALB for NginxDemo
  * Allow SSH from my IP to Ansible Control Node & outbound to private instances
  * Allow HTTP/HTTPS from ALB and SSH from Ansible Control Node for EC2
  * Allow SSH from Ansible Control Node to Nginx ASG instances
  * Restrict SSH to only be allowed from my IP for Ansible control
  
Here's some screenshots of the infrastructure created:

1- VPC

<img width="760" height="147" alt="image" src="https://github.com/user-attachments/assets/286d7f3a-6ac4-4775-8479-f99812652b0d" />

2- Application Load Balancer

<img width="758" height="180" alt="image" src="https://github.com/user-attachments/assets/25c8f03b-5d30-47fb-ba3e-18f20ab498c4" />

3- Auto Scaling Group

<img width="763" height="175" alt="image" src="https://github.com/user-attachments/assets/67828136-2f41-4339-a399-480de0b524a0" />

4- IAM Role for Ansible Control Node

<img width="738" height="262" alt="image" src="https://github.com/user-attachments/assets/e6d0461d-a5eb-4680-bf3d-3577f7910935" />

5- EC2 Instances

<img width="763" height="257" alt="image" src="https://github.com/user-attachments/assets/c6fb732a-b93b-4641-8bd5-e4a6b06d3693" />


# PART 2: Ansible

1. Playbook Preparation

The playbook consists of 3 main tasks: 1) install nginx, 2) configure nginx to use self-signed certificates and serve https, and 3) create a default index htlm page.

<img width="199" height="169" alt="image" src="https://github.com/user-attachments/assets/1bbdcb27-4581-4ef4-9ded-c43fab90ca1e" />

2. Final Result: Nginx Up and Running using the Load Balancer Public DNS Name (HTTPS)

<img width="588" height="193" alt="image" src="https://github.com/user-attachments/assets/79816ef6-f232-48f1-92c7-ff2dc76ed9a1" />

# PART 3: Packer

1. Packer Linux Nginx AMI 

* Running the Packer AMI build
  
<img width="1304" height="513" alt="image" src="https://github.com/user-attachments/assets/3ade3339-790a-4565-84ce-24ac9ba5619e" />

* Linux AMI

<img width="949" height="418" alt="image" src="https://github.com/user-attachments/assets/dedf6e8c-24c1-4c18-b13d-7b0fd44ed940" />

2. Packer Windows Nginx AMI

* Running the Packer AMI build

Ran through a WinRM problem (still working on it) - however Ansible playbook works fine

<img width="933" height="337" alt="image" src="https://github.com/user-attachments/assets/762be3a5-5ee4-4c2b-b594-3d1100488cd2" />


