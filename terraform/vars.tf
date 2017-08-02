variable "AWS_ACCESS_KEY" {
  default = "AKIAJ4DDYUS4KZ2INGYQ"
}

variable "AWS_SECRET_KEY" {
  default = "4JD/NkZo/7bs9407apgC6zKXFn6NKkpwVZ6r2BKV"
}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_AMIS" {
  type = "map"

  default = {
    us-east-1 = "ami-cd0f5cb6" # ubuntu 16.04
  }
}
