output "my_machine_public_ip" {
  value = "${aws_instance.my_machine.public_ip}"
}
