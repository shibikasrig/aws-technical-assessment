AWS Technical Assessment – README

This repository contains Infrastructure-as-Code (IaC) and documentation for selected tasks from the AWS Technical Assessment.
Included tasks:
 Task 1 – VPC Networking
 Task 2 – EC2 Static Website Hosting
 Task 5 – AWS Scalable Architecture Diagram
 Task 1 — AWS VPC Networking & Subnetting
1️)Brief Explanation of VPC & Subnet Design

I created a custom VPC named Shibikasri_G_VPC with a CIDR block of 10.0.0.0/16 to allow a large and flexible private IP range for future scaling. Inside the VPC, I designed two public and two private subnets, each placed across two different Availability Zones for high availability. The public subnets were routed to an Internet Gateway (IGW) to allow inbound and outbound internet access. The private subnets were configured to use a NAT Gateway placed in a public subnet so they can reach the internet securely without exposing their instances publicly. Separate route tables were created and associated with the respective subnets to maintain proper and secure routing.

2️)CIDR Ranges Used & Rationale
Component	Name	CIDR Block	Reason
VPC	Shibikasri_G_VPC	10.0.0.0/16	Large block for subnets & growth
Public Subnet 1	Shibikasri_G_Public_Subnet_1	10.0.1.0/24	AZ1 public resources
Public Subnet 2	Shibikasri_G_Public_Subnet_2	10.0.2.0/24	AZ2 redundancy
Private Subnet 1	Shibikasri_G_Private_Subnet_1	10.0.3.0/24	Backend workloads AZ1
Private Subnet 2	Shibikasri_G_Private_Subnet_2	10.0.4.0/24	Backend workloads AZ2

Reasoning:
/24 provides 256 IPs per subnet—ideal for free-tier projects, Auto Scaling, and future service additions.

3️)Screenshots to Include

Create a folder:
/task1-vpc-networking/screenshots/
Add:
VPC
Subnets
Public Route Table
Private Route Table
Internet Gateway
NAT Gateway

4️)Terraform Code Location

Folder: /task1-vpc-networking
Files:
main.tf
variables.tf
outputs.tf
README.md

 Task 2 — EC2 Static Website Hosting (Nginx Resume Site)
1️)Brief Explanation 
I launched a Free Tier EC2 instance (Amazon Linux 2) in the public subnet created in Task 1. 
A new Security Group was created allowing HTTP (80) and SSH (22) from my IP. After connecting via SSH,
I installed and configured Nginx to serve my static resume HTML files from /usr/share/nginx/html. 
Basic security hardening was applied including disabling password SSH login, updating packages, and restricting inbound rules.
The website was verified to be publicly accessible over port 80 using the instance's public IP.

2️)Required Screenshots

Add folder:
/task2-ec2-static-website/screenshots/

Include:
EC2 instance details
Security Group inbound rules
Website loaded in browser using Public IP

3️)Terraform / Setup Script

Folder: /task2-ec2-static-website

Include:
main.tf
userdata.sh (optional)
README.md

 Task 5 — Scalable AWS Architecture (draw.io Diagram)
1️)Brief Architecture Explanation 
The architecture is designed for a highly scalable web application supporting 10,000+ concurrent users. Traffic enters through an Internet-facing Application Load Balancer (ALB) placed in public subnets. The ALB distributes traffic across an Auto Scaling Group (ASG) deployed across multiple private subnets to ensure high availability. Application state is stored in an RDS/Aurora database, while caching is handled by ElastiCache Redis for high-speed performance. Security is enforced using Security Groups, Network ACLs, and optionally AWS WAF. Observability is achieved using CloudWatch metrics, logs, and alarms, ensuring real-time monitoring and auto-healing.
 Diagram Upload
Place your exported .png or .pdf here:
/task5-architecture-diagram/architecture.png

 
