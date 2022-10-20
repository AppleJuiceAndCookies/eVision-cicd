resource "aws_s3_bucket" "s3_artifacts_bucket" {
  bucket = var.artifacts_bucket_name
}

resource "aws_s3_bucket_versioning" "s3_artifacts_bucket_versioning" {
  bucket = aws_s3_bucket.s3_artifacts_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
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
      name              = "Source"
      category          = "Source"
      owner             = "AWS"
      provider          = "CodeStarSourceConnection"
      version           = 1
      output_artifacts  = ["SourceArtifact"]
      input_artifacts   = []

      configuration     = {
        BranchName            = var.repository_branch
        FullRepositoryId      = "${var.github_organization}/${var.github_repository}"
        ConnectionArn         = aws_codestarconnections_connection.eVision.arn
        OutputArtifactFormat  = "CODEBUILD_CLONE_REF" #"CODE_ZIP"
      }
      run_order         = 1
    }

    # action {
    #   name              = "AppSpec"
    #   category          = "Source"
    #   owner             = "AWS"
    #   provider          = "S3"
    #   version           = "1"
    #   output_artifacts  = ["AppSpec"]
    #   input_artifacts   = []

    #   configuration     = {
    #     S3Bucket = "${aws_s3_bucket.s3_artifacts_bucket.bucket}"
    #     S3ObjectKey = "appspec.yaml"
    #     PollForSourceChanges = false #https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-S3.html
    #   }
    #   run_order         = 1
    # }

    # action {
    #   name             = "TaskDef"
    #   category         = "Source"
    #   owner            = "AWS"
    #   provider         = "S3"
    #   version          = "1"
    #   output_artifacts = ["TaskDef"]
    #   input_artifacts  = []

    #   configuration    = {
    #     S3Bucket = "${aws_s3_bucket.s3_artifacts_bucket.bucket}"
    #     S3ObjectKey = "taskdef.json"
    #     PollForSourceChanges = false
    #   }
    #   run_order       = 1
    # }
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
              # type  = "PLAINTEXT"
              value = var.env
            },
            {
              name  = "CONTAINER_IMAGE"
              # type  = "PLAINTEXT"
              value = var.CONTAINER_IMAGE
            },
            {
              name  = "IMAGE_REPO_NAME"
              # type  = "PLAINTEXT"
              value = var.IMAGE_REPO_NAME
            },
            {
              name  = "ACCOUNT_ID"
              # type  = "PLAINTEXT"
              value = var.ACCOUNT_ID
            },
            {
              name  = "AWS_DEFAULT_REGION"
              # type  = "PLAINTEXT"
              value = var.AWS_DEFAULT_REGION
            },
            {
              name  = "REPOSITORY_URI"
              # type  = "PLAINTEXT"
              value = var.REPOSITORY_URI 
            },
            {
              name  = "CONTAINER_PORT"
              # type  = "PLAINTEXT"
              value = var.CONTAINER_PORT
            },
            {
              name  = "CONTAINER_ROLE_ARN"
              # type  = "PLAINTEXT"
              value = var.CONTAINER_ROLE_ARN
            },
            {
              name  = "ECS_TASK_DEFINITION"
              # type  = "PLAINTEXT"
              # value = var.CONTAINER_IMAGE
              value = "${aws_ecs_task_definition.eVision_task.arn}"
            },
            {
              name  = "ECS_CONTAINER_NAME"
              # type  = "PLAINTEXT"
              value = "${aws_ecs_task_definition.eVision_task.family}"
            },
            {
              name  = "ECS_SUBNETS_A"
              # type  = "PLAINTEXT"
              value =  "${aws_default_subnet.eVision_default_subnet_a.id}"
            },
            {
              name  = "ECS_SUBNETS_B"
              # type  = "PLAINTEXT"
              value =  "${aws_default_subnet.eVision_default_subnet_b.id}"
            },
            {
              name  = "ECS_SUBNETS_C"
              # type  = "PLAINTEXT"
              value =  "${aws_default_subnet.eVision_default_subnet_c.id}"
            },
            {
              name  = "ECS_SECURITY_GROUPS"
              # type  = "PLAINTEXT"
              value =  "${aws_security_group.eVision_service_sg.id}"
            },
          ]
        )
        "ProjectName" = "${var.service_name}-build",
        "PrimarySource": "SourceArtifact"
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
      # provider        = "ECS"
      provider = "CodeDeployToECS"
      input_artifacts = [
        "BuildArtifact",
      ]
      run_order        = 1
      version         = "1"

      # configuration = {
      #   ClusterName = var.ecs_cluster_name
      #   ServiceName = var.service_name
      #   FileName    = "imagedefinitions.json" #var.image_file_name
      # }
      configuration = {
        ApplicationName                = "${var.service_name}-service-deploy"
        DeploymentGroupName            = "${var.service_name}-service-deploy-group"
        TaskDefinitionTemplateArtifact = "BuildArtifact"
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "BuildArtifact"
        AppSpecTemplatePath            = "appspec.yaml"
        # Image1ArtifactName             = "BuildArtifact"
        # Image1ContainerName            = "${var.eVision_ecr_repository_url}"
      }
    }
  }
}