# Importa un par de claves EC2 ya existente, necesario para conectarse por SSH
data "aws_key_pair" "Max" {
  key_name = var.ec2_key
}

#  Crea una VPC personalizada


resource "aws_vpc" "max" {
  cidr_block = "10.0.0.0/16"

  // Habilita los nombres DNS para que las instancias puedan usar nombres de host
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-maltamiranda"
  }
}

#  Crea la primera subnet en la zona de disponibilidad "a"
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.max.id
  cidr_block        = "10.0.0.0/28"
  availability_zone = "${var.aws_region}a"
}

#  Crea la segunda subnet en la zona de disponibilidad "b"
resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.max.id
  cidr_block        = "10.0.0.16/28"
  availability_zone = "${var.aws_region}b"
}

# IGW

resource "aws_internet_gateway" "igw" {
  # Se adjunta a la VPC que acabamos de crear
  vpc_id = aws_vpc.max.id

  tags = {
    Name = "VPC-Max-IGW"
  }
}

# Tabla de rutas para la subred pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.max.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Asociación de la Subred a la Tabla de Rutas
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

# Asociación de la Subred a la Tabla de Rutas
resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public_rt.id
}





#  Crea un clúster de MSK (Kafka gestionado por AWS)
resource "aws_msk_cluster" "msk" {
  cluster_name           = var.cluster_name
  kafka_version          = "3.8.x"
  number_of_broker_nodes = 2  # mínimo de alta disponibilidad

  broker_node_group_info {
    instance_type   = "kafka.t3.small"  # configuración mínima para pruebas
    client_subnets  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]  # Subnets distribuidas
    security_groups = [aws_security_group.msk_sg.id]

    storage_info {
      ebs_storage_info {
        volume_size = 50  # Tamaño del disco de cada broker
      }
    }
  }
}

#  Crea un rol IAM para EC2 que le permite asumir permisos
resource "aws_iam_role" "ec2_role" {
  name = "ec2-msk-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

#  Política que permite a EC2 interactuar con MSK (leer brokers, listar nodos, etc.)
resource "aws_iam_policy" "msk_policy" {
  name        = "msk-access-policy"
  description = "Allow access to MSK cluster"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "kafka:DescribeCluster",
        "kafka:GetBootstrapBrokers",
        "kafka:ListNodes"
      ],
      Resource = "*"
    }]
  })
}

#  Asocia la política al rol EC2
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.msk_policy.arn
}

#  Crea un perfil de instancia para EC2 (necesario para usar IAM Role)
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-msk-profile"
  role = aws_iam_role.ec2_role.name
}

#  Instancia EC2 que funcionará como cliente para MSK
resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.subnet1.id
  security_groups             = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true
  key_name                    = data.aws_key_pair.Max.key_name  # Clave SSH para conectarse

  #  Script de bootstrap externo para instalar Kafka CLI (en /scripts/user_data.sh)
  user_data = file("/scripts/user_data.sh")

  tags = {
    Name = "MSK-Client-Instance"
  }
}

# SG para conexión remota a la instancia ec2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "ec2 ssh"
  vpc_id      = aws_vpc.max.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# SG para conexion con MSK 
resource "aws_security_group" "msk_sg" {
  name        = "msk-sg"
  description = "MSK Security Group"
  vpc_id      = aws_vpc.max.id

  ingress {
    from_port   = 9092
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}