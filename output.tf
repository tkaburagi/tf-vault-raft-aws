output "vault_alb" {
  value = aws_alb.vault_alb.dns_name
}

output "vault_public_ip" {
  value = aws_instance.vault_ec2.*.public_ip
}