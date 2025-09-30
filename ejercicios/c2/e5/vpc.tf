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


# Define la Amazon Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  # Bloque de direcciones IP para toda la VPC (ej: una red grande /16)
  cidr_block = "10.0.0.0/26" 
  
  # Habilita los nombres DNS para que las instancias puedan usar nombres de host
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-Minima-TF"
  }
}

# ----------------------------------------------------------------------
# 2. Internet Gateway (IGW) - Permite la comunicación entre la VPC e Internet
# ----------------------------------------------------------------------
resource "aws_internet_gateway" "gw" {
  # Se adjunta a la VPC que acabamos de crear
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "VPC-Minima-IGW"
  }
}

# ----------------------------------------------------------------------
# 3. Subred (Subnet) - Segmento de red para alojar recursos
# ----------------------------------------------------------------------
resource "aws_subnet" "public" {
  # Usa un segmento más pequeño dentro del bloque de la VPC (ej: /24)
  cidr_block        = "10.0.0.16/28" 
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1a" # Define una zona de disponibilidad específica

  # CRUCIAL: Asigna automáticamente una IP pública a las instancias lanzadas en esta subred
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1a"
  }
}

# ----------------------------------------------------------------------
# 4. Tabla de Rutas (Route Table) - Dirige el tráfico
# ----------------------------------------------------------------------

# Tabla de rutas para la subred pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Ruta que dirige todo el tráfico destinado a Internet (0.0.0.0/0) al Internet Gateway (IGW)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Asociación de la Subred a la Tabla de Rutas
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
