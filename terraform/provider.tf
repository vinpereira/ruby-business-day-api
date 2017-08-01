provider "aws" {
  region = "${vars.AWS_REGION}"
}

data "aws_caller_identity" "current" {}
