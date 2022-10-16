resource "aws_s3_bucket" "s3_artifacts_bucket" {
  bucket = var.artifacts_bucket_name
}

resource "aws_codestarconnections_connection" "eVision" {
  name          = "eVisionGitHub"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "eVision_pipeline" {
  name     = "${var.service_name}-pipeline"
  role_arn = var.pipeline_role
  tags     = {
    Environment = var.env
    Name = "${var.service_name}"
  }

  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        BranchName            = var.repository_branch
        FullRepositoryId      = "${var.github_organization}/${var.github_repository}"
        ConnectionArn         = aws_codestarconnections_connection.eVision.arn  #var.github_connection_arn
        OutputArtifactFormat  = "CODE_ZIP"
      }
      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeStarSourceConnection"
      run_order = 1
      version   = 1
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "EnvironmentVariables" = jsonencode(
          [
            {
              name  = "environment"
              type  = "PLAINTEXT"
              value = var.env
            },
            {
              name  = "IMAGE_REPO_NAME"
              type  = "PLAINTEXT"
              value = var.IMAGE_REPO_NAME
            },
            {
              name  = "ACCOUNT_ID"
              type  = "PLAINTEXT"
              value = var.ACCOUNT_ID
            },
            {
              name  = "AWS_DEFAULT_REGION"
              type  = "PLAINTEXT"
              value = var.AWS_DEFAULT_REGION
            },
            {
              name  = "REPOSITORY_URI"
              type  = "PLAINTEXT"
              value = var.REPOSITORY_URI
            },
          ]
        )
        "ProjectName" = "${var.service_name}-build"
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = [
        "BuildArtifact",
      ]
      run_order        = 1
      version         = "1"

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.service_name
      }
    }
  }
}