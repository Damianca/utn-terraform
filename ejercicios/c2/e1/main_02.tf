
# Recurso para crear un archivo local
resource "local_file" "mi_archivo_dos" {
  filename = "${path.module}/hola_dos.txt"
  content  = "¡Hola, este es mi segundo archivo con Terraform! Strix \n"
}
