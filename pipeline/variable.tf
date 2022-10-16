variable "env" {
  description = "Depolyment environment"
  default     = "prom"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "service_name" {
  default = "eVision"
}

variable "repository_branch" {
  description = "Repository branch to connect to"
  default     = "main"
}

variable "github_organization" {
  description = "GitHub repository owner"
  default     = "AppleJuiceAndCookies"
}

variable "github_repository" {
  description = "GitHub repository name"
  default     = "eVision-docker"
}

variable "github_token" {
  description = "GitHub access token used to configure the provider"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "S3 Bucket for storing artifacts"
  default     = "evision" # CodebuildArtifactsBucket
}

variable "ecs_cluster_name" {
  description = "WS Cluster ECS"
  default     = "eVision-cluster"
}

### For buildspec.yml
variable ACCOUNT_ID {
  description = "WS Cluster ECS"
  default     = "564571135814"
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS region"
  default     = "us-east-1"
}

variable REPOSITORY_URI {
  description = "WS Cluster ECS"
  default     = "564571135814.dkr.ecr.us-east-1.amazonaws.com"
}

variable IMAGE_REPO_NAME {
  description = "WS Cluster ECS"
  default     = "evision"
}

### Access
variable "pipeline_role" {
  description = "AWS Role ARN for CI/CD"
  default     = "arn:aws:iam::564571135814:role/AWSPipelineRoleTerraform"
}

variable github_connection_arn {
  description = "AWS GitHub Connection"
}

### Deploy

variable "eVision_ecr_repository_url" {
  description = "AWS ECR Repo URL"
  type = string
  default = "564571135814.dkr.ecr.us-east-1.amazonaws.com/evision"
}

variable "eVision_container_port" {
  type = number
  default = 8080
}