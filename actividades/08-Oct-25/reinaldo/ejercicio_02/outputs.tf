output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID de la subred publica"
  value       = aws_subnet.public.id
}

output "ssh_only_instance_public_ip" {
  description = "IP publica de la instancia con solo SSH"
  value       = aws_instance.ssh_only_instance.public_ip
}

output "ping_only_instance_public_ip" {
  description = "IP publica de la instancia con solo Ping"
  value       = aws_instance.ping_only_instance.public_ip
}

output "security_group_ids" {
  description = "IDs de los Security Groups creados"
  value = {
    ping_only = aws_security_group.ping_only.id
    ssh_only  = aws_security_group.ssh_only.id
  }
}