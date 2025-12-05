Task 1 – AWS VPC Networking & Subnetting Setup

This task involves designing and deploying a basic AWS Virtual Private Cloud (VPC) with public and private subnets, Internet connectivity, and NAT Gateway access for private resources.

1. Brief Explanation of the VPC Design (4–6 lines)

I created a custom VPC named Shibikasri_G_VPC with a CIDR block of 10.0.0.0/16 to allow enough IP address space for future scaling. Within the VPC, I configured two public and two private subnets, each placed across different Availability Zones to support high availability. The public subnets were routed to an Internet Gateway (IGW) for internet access, while the private subnets used a NAT Gateway to enable outbound internet access without exposing the instances publicly. Separate public and private route tables were created and associated with the respective subnets to ensure proper traffic flow.

2. CIDR Ranges Used
Component	Name	CIDR Block	Reason
VPC	Shibikasri_G_VPC	10.0.0.0/16	Large address range for scalability
Public Subnet 1	Shibikasri_G_Public_Subnet_1	10.0.1.0/24	/24 gives 256 IPs; AZ-1 public resources
Public Subnet 2	Shibikasri_G_Public_Subnet_2	10.0.2.0/24	AZ-2 redundancy
Private Subnet 1	Shibikasri_G_Private_Subnet_1	10.0.3.0/24	For backend workloads in AZ-1
Private Subnet 2	Shibikasri_G_Private_Subnet_2	10.0.4.0/24	Backend workloads in AZ-2
Using /24 subnets provides a clean, easy-to-understand structure and enough IPs for typical Free Tier projects.

📷 3. AWS Console Screenshots

Added the following screenshots inside this folder:
VPC Overview
Public & Private Subnets
Public Route Table & Private Route Table
Internet Gateway (IGW) attachment
NAT Gateway & its Elastic IP

(Screenshots uploaded in the repository inside /screenshots/task1/)

✅ 5. How the Network Works
Public subnets route 0.0.0.0/0 → Internet Gateway
Private subnets route 0.0.0.0/0 → NAT Gateway
NAT Gateway is placed in Public Subnet 1
IGW provides inbound/outbound internet access to public subnets
Private subnets access the internet only through NAT (secure, no inbound traffic)
