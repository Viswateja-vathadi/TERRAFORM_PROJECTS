terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-2"
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# All subnets in default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Details for each subnet
data "aws_subnet" "all" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

locals {
  subnet_id = one([
    for s in data.aws_subnet.all :
    s.id if s.availability_zone == "ap-south-2a"
  ])
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = local.subnet_id
  associate_public_ip_address = true

  tags = {
    Name = "ec2-apsouth2a"
  }
}

output "instance_id" {
  value = aws_instance.ec2.id
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
``
