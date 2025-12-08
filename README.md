AWS Technical Assessment – README

This repository contains Infrastructure-as-Code (IaC) and documentation for selected tasks from the AWS Technical Assessment.
Included tasks:
 Task 1 – VPC Networking
 Task 2 – EC2 Static Website Hosting
 Task 3 – High Availability + Auto Scaling
 Task 4 — Billing & Free Tier Cost Monitoring
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

Created a folder:
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


 Task 2 — EC2 Static Website Hosting (Nginx Resume Site)
1️)Brief Explanation 
I launched a Free Tier EC2 instance (Amazon Linux 2) in the public subnet created in Task 1. 
A new Security Group was created allowing HTTP (80) and SSH (22) from my IP. After connecting via SSH,
I installed and configured Nginx to serve my static resume HTML files from /usr/share/nginx/html. 
Basic security hardening was applied including disabling password SSH login, updating packages, and restricting inbound rules.
The website was verified to be publicly accessible over port 80 using the instance's public IP.

2️)Required Screenshots

Added folder:
/task2-ec2-static-website/screenshots/

Included:
EC2 instance details
Security Group inbound rules
Website loaded in browser using Public IP

3️)Terraform / Setup Script
Folder: /task2-ec2-static-website

Task 3 – High Availability + Auto Scaling
Overview
In this task, the infrastructure was upgraded to a highly available and fault-tolerant architecture using an Application Load Balancer (ALB) and an Auto Scaling Group (ASG). The EC2 instances were moved into private subnets to enhance security, ensuring they are not directly exposed to the internet. The ALB was deployed in public subnets to receive incoming traffic and forward it to the backend instances through a target group.

Brief Explanation (4–6 lines)
The application was migrated to a High Availability architecture by introducing an Internet-facing Application Load Balancer (ALB) and configuring an Auto Scaling Group (ASG). A Launch Template was created to define the EC2 configuration, and the ASG uses this template to automatically deploy instances across multiple Availability Zones for redundancy. The EC2 instances were moved to private subnets to improve security while the ALB handles all internet traffic. If an instance becomes unhealthy, the ALB removes it from the target group, and the ASG launches a new healthy instance. This ensures continuous uptime, fault tolerance, and automatic scaling based on demand.

Traffic Flow
Internet → ALB (Public Subnets) → Target Group → EC2 Instances (Private Subnets)

Steps Performed
Created public and private subnets across two Availability Zones.
Deployed an Internet-facing ALB in public subnets.
Created a Launch Template for EC2 instance configuration.
Configured an Auto Scaling Group (ASG) using the Launch Template.
Enabled health checks and attached the ASG to a Target Group.
Verified that unhealthy instances are automatically replaced.
Tested traffic distribution across multiple instances.

Task 4 — Billing & Free Tier Cost Monitoring

1) Brief Explanation
In this task, I set up AWS cost monitoring to make sure I don’t accidentally exceed the Free Tier limits. I created a CloudWatch Billing Alarm that sends me a notification when my estimated monthly cost reaches ₹100. This helps me track any unexpected usage in advance. I also enabled AWS Free Tier usage alerts so that I get notified whenever my free tier limits are close to being used up. These two alerts help beginners like me stay safe from sudden bill increases caused by forgotten resources or misconfigurations.

2) Required Screenshots
Screenshot of the CloudWatch Billing Alarm
Screenshot of the Free Tier Usage Alerts page

 Task 5 — Scalable AWS Architecture (draw.io Diagram)
 
1️)Brief Architecture Explanation 
The architecture is designed for a highly scalable web application supporting 10,000+ concurrent users. Traffic enters through an Internet-facing Application Load Balancer (ALB) placed in public subnets. The ALB distributes traffic across an Auto Scaling Group (ASG) deployed across multiple private subnets to ensure high availability. Application state is stored in an RDS/Aurora database, while caching is handled by ElastiCache Redis for high-speed performance. Security is enforced using Security Groups, Network ACLs, and optionally AWS WAF. Observability is achieved using CloudWatch metrics, logs, and alarms, ensuring real-time monitoring and auto-healing.

 Diagram Uploaded
/task5-architecture-diagram/architecture.png

 
