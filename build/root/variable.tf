variable "region" {
  description = "Region"
  type = string
  default = "us-east-1"
}

variable "prop_tags" {
  description = "Tags"
  type = map(string)
  default = {
      Project = "Codebuild eVision"
      IaC = "Terraform"
  }
}

variable "account_id" {
  description = "AWS Account ID"
  type = string
}

variable "service_role_name" {
  description = "AWS Role for CI/CD"
  type = string
}

variable "user_policy_target_role_arn" {
  description = "AWS IAM Policy for User for access to Roles"
  type = string
}

variable "iam_users_group_name" {
  description = "AWS IAM Policy for User for access to Roles"
  type = string
}

variable "iam_policy_name" {
  description = "AWS IAM Policy for User for access to Roles"
  type = string
}

variable "codebuild_name" {
  description = "Codebuild eVision"
  type = string
  default = "codebuild-eVision-terraform"
}
