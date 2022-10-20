provider "aws" {
  region = var.aws_region
}

#Create security group with firewall rules
resource "aws_security_group" "my_group_security" {
  name        = var.security_group
  description = "security group for Ec2 instance"

  ingress {
    from_port   = 8081
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from jenkis server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}

# Create AWS ec2 instance
resource "aws_instance" "MYJENKINSSERVER" {
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  security_groups= [var.security_group]
  tags= {
    Name = var.tag_name
  }
}

# Create Elastic IP address
resource "aws_eip" "MYJENKINSSERVER" {
  vpc      = true
  instance = aws_instance.MYJENKINSSERVER.id
tags= {
    Name = "my_elastic_ip"
  }
}
