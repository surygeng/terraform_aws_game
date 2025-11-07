terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

# Security group to allow HTTP in, all traffic out 
resource "aws_security_group" "web_sg" {  # what is security group? 
    name        = "terraform_game_web_sg"
    description = "Allow HTTP inboud and all outboud"   

    ingress {
        description = "HTTP from anywhere"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "all outbound" 
        from_port   = 0
        to_port     = 0 
        protocol   = "-1" 
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "default" {
    key_name   = "terraform-game-key"
    public_key = file("~/.ssh/id_rsa.pub")
}


# EC2 instance that runs the game container 
resource "aws_instance" "web" {
    ami           = var.ami_id 
    instance_type = var.instance_type 

    # attach security group (default VPC)
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    key_name               = aws_key_pair.default.key_name

    user_data = <<-EOF
        #!/bin/bash
        set -euxo pipefail

        # Update and install Docker
        apt-get update -y
        apt-get install -y docker.io

        systemctl enable docker
        systemctl start docker

        # (best-effort) stop whatever was on port 80 before
        docker ps --format '{{.ID}} {{.Ports}}' | \
        grep ':80->' | awk '{print $1}' | xargs -r docker stop || true

        # Pull and run your game image
        docker run -d -p 80:8080 ${var.container_image}
    EOF

    tags = {
        Name = terraform-aws-game-demo
    }
}







