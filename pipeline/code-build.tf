data "template_file" "eVision_buildspec" {
  template = "${file("buildspec.yml")}"
  vars = {
    env          = var.env
  }
}

resource "aws_codebuild_project" "eVision_build" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "${var.service_name}-build"
  queued_timeout = 480
  service_role   = var.pipeline_role
  tags = {
    Environment  = var.env
  }

  artifacts {
    encryption_disabled    = false
    name                   = "${var.service_name}-build-${var.env}"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = data.template_file.eVision_buildspec.rendered
    git_clone_depth     = 0
    insecure_ssl        = true
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}