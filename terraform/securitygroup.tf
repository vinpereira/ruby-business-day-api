resource "aws_security_group" "business-days-allow-ssh-http" {
  vpc_id      = "${aws_vpc.business-days-vpc.id}"
  name        = "allow-ssh-http"
  description = "security group that allows ssh, http and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  tags {
    Name = "allow-ssh-http"
  }
}
