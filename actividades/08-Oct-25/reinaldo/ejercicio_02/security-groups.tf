resource "aws_security_group" "ping_only" {
  name        = "ping-only-reinaldo"
  description = "Security Group that allows only Ping ICMP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ICMP Echo Request"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ICMP Responses"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg-ping-reinaldo"
    Environment = var.environment
    Purpose     = "Ping Only"
  }
}

resource "aws_security_group" "ssh_only" {
  name        = "ssh-only-${var.environment}"
  description = "Security Group that allows only SSH traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound responses"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg-ssh-only-${var.environment}"
    Environment = var.environment
    Purpose     = "SSH Only"
  }
}