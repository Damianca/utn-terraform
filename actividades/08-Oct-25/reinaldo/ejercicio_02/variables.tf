variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block para la subred pública"
  type        = string
  default     = "10.0.1.0/24"
}

# variable "key_pair_name" {
#   description = "Nombre del Key Pair existente en AWS"
#   type        = string
#   default     = "my-key-pair"
# }

variable "key_pair_name" {
  description = "Nombre del Key Pair"
  type        = string
  default     = "my-key-pair-dev"  # O usar el generado automáticamente
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
}