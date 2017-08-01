resource "aws_instance" "business-days" {
  ami = "${lookup(var.AWS_AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.business-days-subnet-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.business-days-allow-ssh-http.id}"]

  tags {
    Name = "Business Days"
    api = "business-days"
  }
}
