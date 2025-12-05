AWS Technical Assessment – Terraform + EC2 + Nginx Website Hosting

This repository contains the solution for the AWS Technical Assessment.
The task includes provisioning an EC2 instance using Terraform, installing Nginx, and hosting a personal resume website.

Tasks Completed
1️)EC2 Instance Creation (Terraform)
Created a fully automated Terraform script to:
Launch an EC2 instance (Amazon Linux 2023)
Generate user-data to install and start Nginx
Upload a custom resume website into /usr/share/nginx/html/index.html
Configure security group to allow:
Port 22 → SSH
Port 80 → HTTP
Output: Public IP of the EC2 instance

2)Nginx Installation & Hosting
Nginx automatically installed using startup script
Default Nginx page replaced with Resume Website
Accessible through EC2 Public IP
Example:

http://https://100.31.239.143/

 Project Structure
 aws-assessment
│── 📄 main.tf        → Terraform configuration for EC2 + Security Group
│── 📄 variables.tf   → (Optional) Variables for customization
│── 📄 outputs.tf     → Outputs for EC2 Public IP
│── 📄 README.md      → This documentation

How to Deploy Using Terraform
Step 1 – Initialize Terraform
terraform init
Step 2 – Validate Terraform Configuration
terraform validate
Step 3 – Apply Terraform Script
terraform apply -auto-approve
Step 4 – Copy Public IP and Open in Browser
http://<public-ip>

Cleanup (VERY IMPORTANT to avoid any AWS charges)

Run:
terraform destroy -auto-approve


Then double-check AWS console:
 EC2 instance → terminated
 Elastic IPs → released
 Security Groups → deleted 

 Screenshots 
 uploaded these screenshots inside a /screenshots/ folder:

AWS Console
EC2 Instance Running
Security Group Inbound Rules (Ports 22 + 80)
Nginx Website Running in Browser
Terraform Apply Output
Terraform Destroy Output
