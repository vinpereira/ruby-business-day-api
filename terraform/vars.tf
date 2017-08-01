variable "AWS_ACCESS_KEY" { }

variable "AWS_SECRET_KEY" { }

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_AMIS" {
  type = "map"

  default = {
    us-east-1: "ami-cd0f5cb6" # ubuntu 16.04
  }
}
