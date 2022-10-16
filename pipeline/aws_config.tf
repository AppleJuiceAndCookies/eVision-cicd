provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "pipeline" {
  key_name   = "PipelineTerraform"
  public_key = file("~/.ssh/id_rsa.pub")
}


provider "github" {
  owner = var.github_organization
  token = var.github_token
}

# module "webhooks" {
#   source              = "../../terraform-github-repository-webhooks/"
#   active              = false
#   github_token        = var.github_token
#   github_organization = var.github_organization
#   github_repositories = var.github_repositories
#   webhook_url         = var.webhook_url
#   events              = var.events

#   context = module.this.context
# }

# output "webhook_url" {
#   description = "Webhook URL"
#   value       = module.webhooks.webhook_url
# }