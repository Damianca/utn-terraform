terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "025066285535_AWSPowerUserAccess" # es el perfil que tengas en ~/.aws/credentials
}

# Data source para obtener información de la identidad actual
data "aws_caller_identity" "current" {}

# Output para mostrar el Account ID
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# (Opcional) también puedes ver el ARN y UserId
output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
