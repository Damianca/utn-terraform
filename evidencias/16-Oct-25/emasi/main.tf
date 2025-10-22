
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

# Security Group para RDS PostgreSQL
resource "aws_security_group" "sg" {
  name        = "emasi-ssh-sg"
  description = "emasi-ssh-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["190.173.97.160/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# key

resource "aws_key_pair" "deployer" {
  key_name   = "emasi-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAiX1QibijkolQjILIkXYwd4fLas9rgAFWRy72BfrPnf emasi@AR01ENOT0587"
}

# Launch template
resource "aws_launch_template" "lt" {
  name_prefix   = "emasi-lt"
  image_id      = "ami-0341d95f75f311023"
  instance_type = "t2.micro"
  ebs_optimized = true

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.sg.id]
  }

  key_name = aws_key_pair.deployer.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "emasi-test"
    }
  }
}

# ASG 
resource "aws_autoscaling_group" "asg" {

  name = "emasi-asg"

  vpc_zone_identifier = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]

  desired_capacity   = 1
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  
  health_check_type         = "EC2"
  health_check_grace_period = 120

  capacity_rebalance = true

  tag {
    key                 = "Name"
    value               = "emasi-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "emasi-scale-up"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type         = "ChangeInCapacity"
  scaling_adjustment      = 1
  cooldown                = 60
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "emasi-scale-down"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type         = "ChangeInCapacity"
  scaling_adjustment      = -1
  cooldown                = 60
}

resource "aws_cloudwatch_metric_alarm" "up" {
  alarm_name          = "terraform-test-foobar5-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 60

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "Scale up if CPU >= 60%"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "down" {
  alarm_name          = "terraform-test-foobar5-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "Scale down if CPU <= 20%"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
