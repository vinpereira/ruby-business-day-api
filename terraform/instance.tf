resource "aws_instance" "business-days" {
  ami           = "${lookup(var.AWS_AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.business-days-key-pair.key_name}"

  subnet_id = "${aws_subnet.business-days-subnet-public-1.id}"

  vpc_security_group_ids = ["${aws_security_group.business-days-allow-ssh.id}", "${aws_security_group.business-days-allow-http.id}"]

  iam_instance_profile = "${aws_iam_instance_profile.business-days-deploy-profile.name}"

  tags {
    Name = "Business Days"
  }

  provisioner "file" {
    source      = "scripts/nginx/nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "file" {
    source      = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh",
    ]
  }

  connection {
    user        = "ubuntu"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}

resource "aws_iam_instance_profile" "business-days-deploy-profile" {
  name = "BusinessDaysInstanceProfile"
  role = "${aws_iam_role.ec2-service-role.name}"
}

resource "aws_key_pair" "business-days-key-pair" {
  key_name   = "business_days_key"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
