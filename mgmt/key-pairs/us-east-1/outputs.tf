output "aws_personal_key_pair" {
  value = "${aws_key_pair.my_key_us_east_1.key_name}"
}
