provider "aws" {
  region = "us-east-1"   # Change region if needed
}

# Security Group allowing SSH and HTTP
resource "aws_security_group" "resume_sg" {
  name        = "resume-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = "vpc-074ac7631089dd05d"  # Replace with your VPC ID

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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

# EC2 Instance
resource "aws_instance" "resume_ec2" {
  ami                         = "ami-0fa3fe0fa7920f68e"  # Amazon Linux 2023
  instance_type               = "t3.micro"
  key_name                    = "resume-key"            # Replace with your key pair name
  subnet_id                   = "subnet-0b45b9d21b42a812b"  # Replace with your public subnet
  vpc_security_group_ids      = [aws_security_group.resume_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras enable nginx1
              sudo yum install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo chmod -R 755 /usr/share/nginx/html
              cat <<EOT > /usr/share/nginx/html/index.html
              <!DOCTYPE html>
              <html>
              <head>
                <title>Shibikasri Resume</title>
                <style>
                  body { font-family: Arial, sans-serif; width: 50%; margin: auto; }
                  h1, h2 { color: #2c3e50; }
                  p { line-height: 1.5; }
                </style>
              </head>
              <body>
                <h1>Shibikasri G</h1>
                <p>Email: shibikasri.g2022cse@sece.ac.in</p>
                <p>Phone: +91 7418349930</p>

                <h2>Education</h2>
                <p>B.E CSE, Sri Eshwar College of Engineering, CGPA: 7.04</p>
                <p>HSC 85.8%, Green Park Matric Hr.Sec.School</p>
                <p>SSLC 87.8%, Green Park Matric Hr.Sec.School</p>

                <h2>Internships</h2>
                <p>Data Science at Celebal Tech (Jun-Aug 2025)</p>
                <p>AWS Cloud at DXC Solutions (Aug 2024)</p>

                <h2>Projects</h2>
                <p>JurIS Knowledge Hub - AI legal assistant platform</p>
                <p>Diabetes Risk Predictor - ML web app</p>
                <p>AI Doctor VoiceBot - Real-time voice assistant</p>
                <p>Loan Chatbot - Flask & OpenAI GPT integration</p>

                <h2>Skills</h2>
                <p>Python, HTML, C | Flask, Pandas, Scikit-learn, TensorFlow, PyTorch, LangChain</p>

                <h2>Certifications</h2>
                <p>AWS Academy Graduate – NLP & Generative AI</p>
                <p>Deep Learning, Machine Learning Algorithms, DevOps, Azure 303</p>

                <p><em>Website hosted on AWS EC2 using Terraform & Nginx.</em></p>
              </body>
              </html>
              EOT
              EOF

  tags = {
    Name = "resume-website"
  }
}

output "public_ip" {
  value = aws_instance.resume_ec2.public_ip
}
