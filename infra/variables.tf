variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string # why do you need a type here? 
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu AMI ID for the chosen region"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "container_image" {
  description = "Docker image (surygeng/terraform-aws-game:v0.1)"
  type        = string
}