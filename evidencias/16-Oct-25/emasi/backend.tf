# ----------------------------------------------------------------------
# 1. Bloque de Configuración de Terraform (Backend y Proveedores Requeridos)
# ----------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # CRUCIAL: Reemplaza con tu nombre de bucket (debe ser único globalmente)
    bucket         = "curso-utn-tfstate-damian-new" 
    
    # Ruta del archivo de estado dentro del bucket
    key            = "./emasi/terraform.tfstate" 
    
    # Región del bucket (debe coincidir con la región del provider)
    region         = "us-east-1"
    
    # Tabla DynamoDB para State Locking (previene que dos usuarios apliquen cambios a la vez)
    dynamodb_table = "curso-utn-terraform-damian-locks" 
    
    # Habilita el cifrado de archivos de estado en S3 (Mejor Práctica)
    encrypt        = true
    
    # Usar el bloqueo nativo de S3 (Mejor Práctica, valor booleano)
    use_lockfile   = true 

    profile = "251964342273_FreeTierAccess" # este es el perfil que tengas en ~/.aws/credentials
  }
}

# ----------------------------------------------------------------------
# 2. Bloque del Proveedor (Configuración de Credenciales/Región)
# ----------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
  profile = "251964342273_FreeTierAccess" # este es el perfil que tengas en ~/.aws/credentials
  # Asume que las credenciales están configuradas vía variables de entorno o AWS CLI profile
}



