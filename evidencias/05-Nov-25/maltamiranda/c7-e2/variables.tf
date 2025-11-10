variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
}

variable "cluster_name" {
  description = "Nombre del clúster de MSK"
  type        = string
}

variable "ec2_instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "ec2_ami" {
  description = "AMI usada para las instancias EC2 (Amazon Linux 2023)"
  type        = string
}

variable "ec2_key" {
  description = "Nombre del par de claves EC2 ya creado en AWS"
  type        = string
}
