account_id = "564571135814"
service_role_name = "arn:aws:iam::564571135814:role/AWSServiceRoleTerraform"

codebuild_params = {
      "NAME" = "eVision-codebuild"
      "GIT_REPO" = "https://github.com/AppleJuiceAndCookies/eVision-docker.git"
      "IMAGE" = "aws/codebuild/standard:4.0"
      "TYPE" = "LINUX_CONTAINER"
      "COMPUTE_TYPE" = "BUILD_GENERAL1_SMALL"
      "CRED_TYPE" = "CODEBUILD"
} 
environment_variables = {
      "AWS_DEFAULT_REGION" = "us-east-1"
      "AWS_ACCOUNT_ID" = "564571135814"
      "IMAGE_REPO_NAME" = "evision"
      "IMAGE_TAG" = "1.0.0"
}