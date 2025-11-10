output "msk_bootstrap_brokers_tls" {
  value = aws_msk_cluster.msk.bootstrap_brokers_tls
}

output "ec2_ssh_access" {
  value = "ssh -i ./Max.pem ec2-user@${aws_instance.ec2.public_ip}"
}
