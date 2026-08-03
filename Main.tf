terraform {
  required_version = ">= 1.0"

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

# Create IAM User
resource "aws_iam_user" "admin_user" {
  name = var.iam_user_name
}

# Attach Administrator Access Policy
resource "aws_iam_user_policy_attachment" "admin_access" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create Access Key
resource "aws_iam_access_key" "admin_key" {
  user = aws_iam_user.admin_user.name
}
