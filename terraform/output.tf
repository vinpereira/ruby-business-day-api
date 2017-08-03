output "ip" {
  value = "${aws_instance.business-days.public_ip}"
}
