# Define la región de AWS
provider "aws" {
  region = "us-east-1" # Cambia a tu región preferida
}

# --- 1. Data Sources para obtener el VPC y Subnets por defecto ---

# Data source para obtener el VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Data source para obtener las subredes del VPC por defecto
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# --- 2. Variable para la IP pública ---

variable "my_public_ip" {
  description = "Tu IP pública actual para acceder a la BD (ej. 1.2.3.4)"
  type        = string
  # IMPORTANTE: Reemplaza esto con tu IP pública en formato CIDR (ej: "203.0.113.4/32")
  default     = "190.189.102.126/32" 
}

# --- 3. Security Group (SG) Corregido ---

resource "aws_security_group" "rds_access" {
  name        = "rds-postgres-access-sg"
  # CORRECCIÓN: Descripción sin tildes para evitar el error de caracteres no ASCII
  description = "Permite trafico PostgreSQL solo desde mi IP publica" 
  vpc_id      = data.aws_vpc.default.id

  # Regla de entrada: PostgreSQL (5432) desde tu IP
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip] # Acceso restringido a tu IP
    description = "PostgreSQL access from my IP"
  }

  # Regla de salida: permitir todo
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-postgres-access"
  }
}

# --- 4. DB Subnet Group ---

resource "aws_db_subnet_group" "default_vpc_subnets" {
  name        = "rds-subnet-group"
  subnet_ids  = data.aws_subnets.default.ids
  description = "Subnet group for default VPC subnets"

  tags = {
    Name = "Default-VPC-Subnets-for-RDS"
  }
}

# --- 5. Despliegue de aws_db_instance (PostgreSQL) ---

resource "aws_db_instance" "postgres_instance" {
  # Configuración básica
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "17.4" 
  instance_class         = "db.t3.micro" 
  db_name                = "mipostgresdb"      # Nombre de la BD
  username               = "dbadmin"           # Usuario maestro
  password               = "password" # ¡Cambia esta contraseña!
  skip_final_snapshot    = true                # Para entorno de prueba
  publicly_accessible    = true                # Necesario para acceder desde fuera

  # Networking y Seguridad
  vpc_security_group_ids = [aws_security_group.rds_access.id]
  db_subnet_group_name   = aws_db_subnet_group.default_vpc_subnets.name

  # Identificación
  identifier = "mi-rds-postgres"

  tags = {
    Name = "Mi-RDS-PostgreSQL"
  }
}

# --- 6. Outputs para la conexión ---

output "db_endpoint" {
  description = "El endpoint para conectarte a la base de datos PostgreSQL."
  value       = aws_db_instance.postgres_instance.address
}

output "db_name" {
  description = "El nombre de la base de datos."
  value       = aws_db_instance.postgres_instance.db_name
}