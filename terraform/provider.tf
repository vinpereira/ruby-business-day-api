provider "aws" {
  region = "${var.AWS_REGION}"
}

data "aws_caller_identity" "current" {}
