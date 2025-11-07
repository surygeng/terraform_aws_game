terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Security group allowing HTTP in, all outbound
resource "aws_security_group" "web_sg" {
  name        = "terraform-game-web-sg"
  description = "Allow HTTP inbound and all outbound"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance that runs your game container
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    apt-get update -y
    apt-get install -y docker.io

    systemctl enable docker
    systemctl start docker

    # Pull and run your game image on port 80 -> 8080 in container
    docker run -d -p 80:8080 ${var.container_image}
  EOF

  tags = {
    Name = "terraform-aws-game-demo"
  }
}
