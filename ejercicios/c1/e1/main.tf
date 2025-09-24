# Proveedor -provider- local
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

# Recurso para crear un archivo local
resource "local_file" "mi_archivo" {
  filename = "${path.module}/hola.txt"
  content  = "¡Hola, este es mi primer archivo con Terraform! Strix \n"
}
