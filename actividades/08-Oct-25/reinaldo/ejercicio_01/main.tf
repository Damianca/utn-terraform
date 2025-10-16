provider "aws" {
  region = "us-east-1" 
}

resource "aws_s3_bucket" "bucket_ejemplo" {
  bucket = "bucket-ejemplo-1-cancino" 

  tags = {
    Name        = "Bucket Ejemplo Terraform"
    Environment = "Dev"
  }
}

data "aws_s3_bucket" "bucket_data" {
  bucket = aws_s3_bucket.bucket_ejemplo.id
}

output "nombre_del_bucket_recuperado" {
  description = "El nombre del bucket S3 recuperado mediante el bloque de datos."
  value       = data.aws_s3_bucket.bucket_data.id
}