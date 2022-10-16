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
      IaC = "TerraformEVision"
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

variable "codebuild_name" {
  description = "Codebuild eVision"
  type = string
  default = "codebuild-eVision-terraform-test"
}

variable "codebuild_params" {
  description = "Codebuild parameters"
  type = map(string)
}

variable "environment_variables" {
  description = "Environment variables"
  type = map(string)
}