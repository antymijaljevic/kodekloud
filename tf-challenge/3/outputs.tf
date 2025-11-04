# output "private_key" {
#   value     = tls_private_key.key_pair.private_key_pem
#   sensitive = true
# }

output "public_ip" {
  value = aws_eip.eip
}