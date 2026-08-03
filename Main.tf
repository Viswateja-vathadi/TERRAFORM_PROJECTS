provider "aws" {
  region = ap-south-2
}

resource "aws_iam_user" "admin_user" {
  name = var.iam_user_name
}

resource "aws_iam_user_policy_attachment" "admin_access" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
