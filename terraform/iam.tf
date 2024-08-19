resource "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "CodeDeployServiceRole"
  }
}

resource "aws_iam_policy_attachment" "codedeploy_role_attachment" {
  name       = "codedeploy_role_attachment"
  roles      = [aws_iam_role.codedeploy_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_instance_profile" "codedeploy_instance_profile" {
  name = "CodeDeployInstanceProfile"
  role = aws_iam_role.codedeploy_role.name
}