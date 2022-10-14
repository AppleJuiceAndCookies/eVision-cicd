provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "DeployerTerraform"
  public_key = file("~/.ssh/id_rsa.pub")
}
