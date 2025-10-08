# Crear el bucket S3
resource "aws_s3_bucket" "ejemplo_bucket" {
  bucket = "bucket-ejemplo-1-${lower(var.apellido)}"
}

# Recuperar el nombre del bucket (ej: para usarlo en otro recurso o salida)
# Aquí lo mostramos como salida
output "nombre_del_bucket" {
  value = aws_s3_bucket.ejemplo_bucket.bucket
}

# Opcional: hacer el bucket privado (mejor práctica)
resource "aws_s3_bucket_public_access_block" "ejemplo_bucket_block" {
  bucket = aws_s3_bucket.ejemplo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}