// ====================================================================
// Configuración del backend de Terraform (estado remoto en S3)
// ====================================================================
terraform {
  backend "s3" {
    bucket         = "terraform-state-tpi-maximiliano"       // Nombre único del bucket S3
    key            = "global/s3/terraform.tfstate"           // Ruta dentro del bucket
    region         = "us-east-1"                             // Región del bucket
    #dynamodb_table = "terraform-state-tpi-maximiliano-locks" // Tabla para lockeo
    encrypt        = true                                    // Cifrado del tfstate
    use_lockfile = true
    profile        = "251964342273_FreeTierAccess"
  }
}
