# Define el proveedor AWS y establece la región
provider "aws" {
  # IMPORTANTE: Reemplaza "us-east-1" con la región de AWS que desees usar.
  region = "us-east-1" 
}

## 1. Crear un bucket S3 llamado "bucket-ejemplo-1-TU_APELLIDO"

# Recurso para crear el bucket S3
resource "aws_s3_bucket" "bucket_ejemplo" {
  # Asegúrate de reemplazar "TU_APELLIDO" con tu apellido real.
  bucket = "bucket-ejemplo-1-cancino" 

  tags = {
    Name        = "Bucket Ejemplo Terraform"
    Environment = "Dev"
  }
}

# NOTA: Se ha omitido el recurso 'aws_s3_bucket_acl' para evitar el error
# 'AccessControlListNotSupported' y seguir las mejores prácticas de AWS.


## 2. Recuperar el nombre del bucket anterior

# Bloque de datos para obtener información sobre un bucket S3 existente
# Usa el ID del bucket creado en el paso 1.
data "aws_s3_bucket" "bucket_data" {
  bucket = aws_s3_bucket.bucket_ejemplo.id
}

# Salida para mostrar el nombre recuperado del bucket
output "nombre_del_bucket_recuperado" {
  description = "El nombre del bucket S3 recuperado mediante el bloque de datos."
  # Muestra el nombre del bucket obtenido del bloque de datos
  value       = data.aws_s3_bucket.bucket_data.id
}