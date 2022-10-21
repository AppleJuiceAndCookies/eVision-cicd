provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "builder" {
  key_name   = "Terraform"
  public_key = file("~/.ssh/id_rsa.pub")
}