resource "aws_instance" "ssh_only_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.generated.key_name
  vpc_security_group_ids      = [aws_security_group.ssh_only.id]
  associate_public_ip_address = true

  tags = {
    Name        = "ec2-ssh-only-${var.environment}"
    Environment = var.environment
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3
              EOF

  depends_on = [aws_internet_gateway.main]
}

resource "aws_instance" "ping_only_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.generated.key_name
  vpc_security_group_ids      = [aws_security_group.ping_only.id]
  associate_public_ip_address = true

  tags = {
    Name        = "ec2-ping-only-${var.environment}"
    Environment = var.environment
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3
              EOF

  depends_on = [aws_internet_gateway.main]
}