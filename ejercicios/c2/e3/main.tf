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
    bucket         = "curso-utn-tfstate-damian" 
    
    # Ruta del archivo de estado dentro del bucket
    key            = "./terraform.tfstate" 
    
    # Región del bucket (debe coincidir con la región del provider)
    region         = "us-east-1"
    
    # Tabla DynamoDB para State Locking (previene que dos usuarios apliquen cambios a la vez)
    dynamodb_table = "curso-utn-terraform-damian-locks" 
    
    # Habilita el cifrado de archivos de estado en S3 (Mejor Práctica)
    encrypt        = true
    
    # Usar el bloqueo nativo de S3 (Mejor Práctica, valor booleano)
    use_lockfile   = true 
  }
}

# ----------------------------------------------------------------------
# 2. Bloque del Proveedor (Configuración de Credenciales/Región)
# ----------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
  profile = "025066285535_AWSAdministratorAccess" # este es el perfil que tengas en ~/.aws/credentials
  # Asume que las credenciales están configuradas vía variables de entorno o AWS CLI profile
}

# 2. Referencia a la Subred Existente (Data Source)
# La data source 'aws_subnet' busca una subred existente por su ID.
data "aws_subnet" "target_subnet" {
  id = "subnet-0287bc470ed106acb"
}

# 3. Uso de la Subred (Ejemplo: Mostrar atributos de la subred)
# El 'output' te permite verificar que Terraform ha encontrado la subred correcta.
output "subnet_info" {
  description = "Información de la subred referenciada"
  value = {
    subnet_id         = data.aws_subnet.target_subnet.id
    cidr_block        = data.aws_subnet.target_subnet.cidr_block
    availability_zone = data.aws_subnet.target_subnet.availability_zone
    vpc_id            = data.aws_subnet.target_subnet.vpc_id
  }
}

# 4. Ejemplo de Creación de un Recurso Usando la Subred (Opcional)
resource "aws_instance" "example" {
  ami           = "ami-08982f1c5bf93d976" # Reemplazar con una AMI válida
  instance_type = "t2.micro"
  # Asocia el EC2 a la subred existente usando el atributo 'id'
  subnet_id = data.aws_subnet.target_subnet.id
  
  tags = {
    Name = "ejemploBorrame_damian"
  }
}

