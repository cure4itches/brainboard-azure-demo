output "ssh-private-key" {
  sensitive = true
  value     = tls_private_key.demo-ssh-key.private_key_pem
}

