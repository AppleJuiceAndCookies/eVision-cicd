resource "aws_codepipeline_webhook" "eVision_codepipeline_webhook" {
  authentication  = "GITHUB_HMAC"
  name            = "${var.service_name}-codepipeline-webhook"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.eVision_pipeline.name

  authentication_configuration {
    secret_token = random_string.eVision_github_secret.result
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
  tags = {}
}

# resource "github_repository_webhook" "eVision_github_hook" {
#   repository = var.github_repository
#   events     = ["push"]

#   configuration {
#     url          = aws_codepipeline_webhook.eVision_codepipeline_webhook.url
#     insecure_ssl = false
#     content_type = "json"
#     # secret       = random_string.eVision_github_secret.result
#   }
# }

resource "random_string" "eVision_github_secret" {
  length  = 99
  special = false
}
