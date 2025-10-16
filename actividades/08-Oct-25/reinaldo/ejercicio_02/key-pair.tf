# Generar clave privada
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Crear Key Pair en AWS
resource "aws_key_pair" "generated" {
  key_name   = "my-key-pair-${var.environment}"
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Guardar la clave privada localmente
resource "local_file" "private_key" {
  content  = tls_private_key.this.private_key_pem
  filename = "${path.module}/my-key-pair-${var.environment}.pem"
  # filename = "${path.module}/key3"
  file_permission = "0400"
}