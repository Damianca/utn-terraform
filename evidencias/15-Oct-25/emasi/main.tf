
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
resource "aws_subnet" "public_1a" {
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

resource "aws_subnet" "public_1b" {
  # Usa un segmento más pequeño dentro del bloque de la VPC (ej: /24)
  cidr_block        = "10.0.0.32/28" 
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1b" # Define una zona de disponibilidad específica

  # CRUCIAL: Asigna automáticamente una IP pública a las instancias lanzadas en esta subred
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1b"
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
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

# Asociación de la Subred a la Tabla de Rutas
resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

# Security Group para RDS PostgreSQL
resource "aws_security_group" "rds_security_group_emasi" {
  name        = "rds-sg-emasi"
  description = "Permite acceso a PostgreSQL desde mi IP publica"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "5432"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["190.173.113.196/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crear el grupo de subnets para RDS
resource "aws_db_subnet_group" "rds_subnet_group_emasi" {
  name       = "rds-subnet-group-emasi"
  subnet_ids = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
}

# Instancia RDS PostgreSQL
resource "aws_db_instance" "rds_postgre_sql" {
  identifier              = "rds-postgre-sql-emasi"
  engine                  = "postgres"
  engine_version          = "16.3"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group_emasi.name
  vpc_security_group_ids  = [aws_security_group.rds_security_group_emasi.id]
  publicly_accessible     = true
  username                = "postgres"
  password                = "Strix123!"
}