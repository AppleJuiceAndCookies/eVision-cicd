### Get Data From Files
data "local_file" "assumeRole_policy" {
  filename = "policy/assumeRole.json"
}

data "local_file" "policy" {
  filename = "policy/policy.json"
}

### Create Role for CICD
resource "aws_iam_role" "role" {
  name               = var.service_role_name
  assume_role_policy = data.local_file.assumeRole_policy.content
}

### Create Policy for CICD
resource "aws_iam_role_policy" "evision" {
  role      = aws_iam_role.role.name
  policy    = replace(replace(data.local_file.policy.content, "ACCOUNT_ID", var.account_id), "CODEBUILD_NAME", var.codebuild_name)
}

### Create Policy for grop DevOps for technical users
resource "aws_iam_group_policy" "get_role_policy" {
  name    = var.iam_policy_name
  group   = var.iam_users_group_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "iam:GetRole",
          "iam:PassRole"
        ],
        "Resource": var.user_policy_target_role_arn
      }
    ]
  })
}