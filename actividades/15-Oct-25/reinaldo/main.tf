provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


variable "my_public_ip" {
  description = "Tu IP pública actual para acceder a la BD (ej. 1.2.3.4)"
  type        = string
  default     = "TU-IP-PUBLICA/32"
}


resource "aws_security_group" "rds_access" {
  name        = "rds-postgres-access-sg"
  description = "Permite trafico PostgreSQL solo desde mi IP publica" 
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip] 
    description = "PostgreSQL access from my IP"
  }

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


resource "aws_db_subnet_group" "default_vpc_subnets" {
  name        = "rds-subnet-group"
  subnet_ids  = data.aws_subnets.default.ids
  description = "Subnet group for default VPC subnets"

  tags = {
    Name = "Default-VPC-Subnets-for-RDS"
  }
}


resource "aws_db_instance" "postgres_instance" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "17.4" 
  instance_class         = "db.t3.micro" 
  db_name                = "mipostgresdb"      
  username               = "dbadmin"           
  password               = "password" 
  skip_final_snapshot    = true       
  publicly_accessible    = true       

  vpc_security_group_ids = [aws_security_group.rds_access.id]
  db_subnet_group_name   = aws_db_subnet_group.default_vpc_subnets.name

  identifier = "mi-rds-postgres"

  tags = {
    Name = "Mi-RDS-PostgreSQL"
  }
}


output "db_endpoint" {
  description = "El endpoint para conectarte a la base de datos PostgreSQL."
  value       = aws_db_instance.postgres_instance.address
}

output "db_name" {
  description = "El nombre de la base de datos."
  value       = aws_db_instance.postgres_instance.db_name
}