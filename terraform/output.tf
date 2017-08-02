output "secret" {
  value = "${aws_iam_access_key.travis-access-key.encrypted_secret}"
}

output "ip" {
  value = "${aws_instance.business-days.public_ip}"
}
