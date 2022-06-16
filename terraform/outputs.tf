output "connect_to_ec2" {
  value = "ssh -i '${aws_key_pair.generated_key.key_name}.pem' ec2-user@${aws_instance.web.public_ip}"
}