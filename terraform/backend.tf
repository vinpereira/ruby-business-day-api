terraform {
  backend "s3" {
    bucket = "terraform-state-business-days"
    key    = "terraform/business-days"
    region = "us-east-1"
  }
}
