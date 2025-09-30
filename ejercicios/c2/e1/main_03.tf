
# Recurso para crear un archivo local
resource "local_file" "mi_archivo_tres" {
  filename = "${path.module}/hola_tres.txt"
  content  = "¡Hola, este es mi tercer archivo con Terraform! Strix \n"
}
