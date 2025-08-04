resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = local.ssh_key_pair_name
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = merge(local.common_tags, {
    Name = local.ssh_key_pair_name
  })
}