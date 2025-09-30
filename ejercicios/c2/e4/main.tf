# ----------------------------------------------------------------------
# 1. Recurso: aws_s3_bucket
# ----------------------------------------------------------------------
resource "aws_s3_bucket" "bucket_dev" {
 
  bucket = "${var.nombre_s3}" 

  tags = {
    Name = upper(var.nombre_s3)
    Unique_ID = "${var.nombre_s3}"
  }
}




# ----------------------------------------------------------------------
# 2. Salida para Ver el Nombre Generado
# ----------------------------------------------------------------------
output "final_bucket_name" {
  description = "Nombre final del bucket S3 generado."
  value       = aws_s3_bucket.bucket_dev.id
}
