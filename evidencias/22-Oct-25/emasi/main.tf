
# Define la Amazon Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  # Bloque de direcciones IP para toda la VPC (ej: una red grande /16)
  cidr_block = "10.0.0.0/26" 
  
  # Habilita los nombres DNS para que las instancias puedan usar nombres de host
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "emasi-VPC-Minima-TF"
  }
}

# ----------------------------------------------------------------------
# 2. Internet Gateway (IGW) - Permite la comunicación entre la VPC e Internet
# ----------------------------------------------------------------------
resource "aws_internet_gateway" "gw" {
  # Se adjunta a la VPC que acabamos de crear
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "emasi-VPC-Minima-IGW"
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
    Name = "emasi-Public-Subnet-1a"
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
    Name = "emasi-Public-Subnet-1b"
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
    Name = "emasi-Public-Route-Table"
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

# Cluster EKS en modo Auto-Mode
resource "aws_eks_cluster" "example" {
  name = "emasi-eks"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.32"

  bootstrap_self_managed_addons = false

  compute_config {
    enabled       = true
    node_pools    = ["general-purpose"]
    node_role_arn = aws_iam_role.node.arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.public_1a.id,
      aws_subnet.public_1b.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
  ]
}

resource "aws_iam_role" "node" {
  name = "eks-auto-node-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodeMinimalPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSComputePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSBlockStoragePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSLoadBalancingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSNetworkingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.cluster.name
}