output "vault_alb" {
  value = aws_alb.vault_alb.dns_name
}