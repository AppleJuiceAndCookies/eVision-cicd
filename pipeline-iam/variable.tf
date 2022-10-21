variable "account_id" {
  description = "AWS User for CI/CD"
  type        = string
  default     = "564571135814"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "iam_users_group_name" {
  description = "AWS IAM Policy for User for access to Roles"
  type        = string
  default     = "DevOps"
}

variable "pipeline_role_name" {
  description = "AWS IAM Policy for User for access to Roles"
  type        = string
  default     = "AWSPipelineRoleTerraform"
}

variable "iam_group_policy" {
  description = "IAM Group Policy Name"
  type        = string
  default     = "AWSGetPassRolesTerraform"
}

# variable "pipeline_role" {
#   description = "AWS Role for CI/CD"
#   default     = "arn:aws:iam::564571135814:role/AWSPipelineRoleTerraform"
# }

variable "codebuild_name" {
  description = "Codebuild Name"
  type        = string
  default     = "eVision-build"
}
