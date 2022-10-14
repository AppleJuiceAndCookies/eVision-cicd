
resource "aws_iam_role" "eVision_ecsTaskExecutionRole" {
  name               = "AWSECSTaskExecutionRoleTerraform"
  assume_role_policy = "${data.aws_iam_policy_document.eVision_assume_role_policy.json}"
}

data "aws_iam_policy_document" "eVision_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eVision_ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.eVision_ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

### Create Policy for grop DevOps for technical deployer user
resource "aws_iam_group_policy" "get_ecs_role_policy" {
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
        "Resource": "${aws_iam_role.eVision_ecsTaskExecutionRole.arn}"
      }
    ]
  })
}