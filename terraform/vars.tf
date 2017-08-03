variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_AMIS" {
  type = "map"

  default = {
    us-east-1 = "ami-cd0f5cb6" # ubuntu 16.04
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "keys/business_days_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/business_days_key.pub"
}
