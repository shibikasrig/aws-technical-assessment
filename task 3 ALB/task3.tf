
PROVIDER
provider "aws" {
  region = "us-east-1"
}

DATA SOURCES (import VPC & Subnets from Task 1)
data "aws_vpc" "task1_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Shibikasri_G_VPC"]
  }
}
data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = ["Shibikasri_G_Public_1"]
  }
}
data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = ["Shibikasri_G_Public_2"]
  }
}
data "aws_subnet" "private_1" {
  filter {
    name   = "tag:Name"
    values = ["Shibikasri_G_Private_1"]
  }
}
data "aws_subnet" "private_2" {
  filter {
    name   = "tag:Name"
    values = ["Shibikasri_G_Private_2"]
  }
}

SECURITY GROUP FOR PRIVATE EC2

resource "aws_security_group" "private_ec2_sg" {
  name        = "Shibikasri_Task3_Private_EC2_SG"
  description = "Allow SSH from my IP"
  vpc_id      = data.aws_vpc.task1_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP/32"]  # Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Shibikasri_Task3_Private_EC2_SG"
  }
}

LAUNCH TEMPLATE (PRIVATE EC2)

resource "aws_launch_template" "task3_lt" {
  name_prefix   = "Shibikasri_Private_EC2_Task3"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  key_name = "YOUR_KEY"  # Replace with your AWS key pair name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private_ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Shibikasri_Private_EC2_Task3"
    }
  }
}

TARGET GROUP (HTTP 80)

resource "aws_lb_target_group" "task3_tg" {
  name        = "Shibikasri_Task3_TG"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.task1_vpc.id

  health_check {
    path = "/"
    port = "80"
  }
}

SECURITY GROUP FOR ALB

resource "aws_security_group" "alb_sg" {
  name        = "Shibikasri_Task3_ALB_SG"
  vpc_id      = data.aws_vpc.task1_vpc.id
  description = "Allow HTTP from anywhere"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

APPLICATION LOAD BALANCER (ALB)

resource "aws_lb" "task3_alb" {
  name               = "Shibikasri_Task3_ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = [
    data.aws_subnet.public_1.id,
    data.aws_subnet.public_2.id
  ]
}

LISTENER (ALB → TARGET GROUP)

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.task3_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task3_tg.arn
  }
}

AUTO SCALING GROUP (ASG)

resource "aws_autoscaling_group" "task3_asg" {
  name                      = "Shibikasri_Task3_ASG"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1

  vpc_zone_identifier = [
    data.aws_subnet.private_1.id,
    data.aws_subnet.private_2.id
  ]

  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.task3_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.task3_tg.arn]

  tag {
    key                 = "Name"
    value               = "Shibikasri_Task3_EC2"
    propagate_at_launch = true
  }
}
