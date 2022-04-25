output "ssh-private-key" {
  sensitive = true
  value     = tls_private_key.demo_ssh_key.private_key_pem
}

output "vm-public-ip" {
  sensitive = false
  value     = "${azurerm_public_ip.demo-publicip.*.ip_address}"
}

