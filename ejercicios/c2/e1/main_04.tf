
# Recurso para crear un archivo local
resource "local_file" "mi_archivo_cuatro" {
  filename = "${path.module}/hola_cuatro.txt"
  content  = "¡Hola, este es mi cuarto archivo con Terraform! Strix \n"
}
