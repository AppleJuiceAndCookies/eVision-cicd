data "local_file" "assume_role" {
  filename = "policy/assumeRole.json"
}

data "local_file" "iam_policy" {
  filename = "policy/iam-policy.json"
}

data "local_file" "pipeline_policy" {
  filename = "policy/pipeline-policy.json"
}

resource "aws_iam_role" "iam_role" {
  name               = var.pipeline_role_name
  assume_role_policy = data.local_file.assume_role.content
}

resource "aws_iam_role_policy" "pipeline_role_policy" {
  role      = aws_iam_role.iam_role.name
  policy    = replace(replace(data.local_file.pipeline_policy.content, "ACCOUNT_ID", var.account_id), "CODEBUILD_NAME", var.codebuild_name)
}

resource "aws_iam_group_policy" "iam_group_policy" {
  name    = var.iam_group_policy
  group   = var.iam_users_group_name
  policy  = replace(replace(data.local_file.iam_policy.content, "ACCOUNT_ID", var.account_id), "PIPELINE_ROLE_NAME", var.pipeline_role_name)
}