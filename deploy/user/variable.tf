variable "eVision_ecs_cluster_name" {
  description = "AWS Cluster ECS"
  type = string
  default = "eVision-cluster"
}

variable "IAMecsTaskExecutionRoleARN" {
  description = "AWS IAM ROLE arn for access to ecr and logs"
  type = string
}

variable "eVision_ecr_repository_url" {
  description = "AWS ECR Repo URL"
  type = string
}

variable "eVision_container_port" {
  type = number
}