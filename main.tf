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

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-south-1"
}

resource "aws_security_group" "ssh_sg" {
  name = "allow-ssh"

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "Vault Access"
    from_port   = 8200
    to_port     = 8200
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

resource "aws_instance" "Ubuntu" {
  ami           = "ami-07a00cf47dbbc844c" # Ubuntu server 26.04 LTS (HVM), SSD Volume Type
  instance_type = "t3.micro"
  key_name = "SSH login"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.ssh_sg.id
  ]

  tags = {
    Name = "Sample VM"
  } 
  
}

