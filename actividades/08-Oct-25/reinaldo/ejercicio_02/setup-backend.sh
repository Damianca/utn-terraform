#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BUCKET_NAME="bucket-ejemplo-1-cancino"
REGION="us-east-1"
TABLE_NAME="terraform-locks-cancino"
MAIN_TF_FILE="main.tf"
BACKEND_TF_FILE="backend.tf"

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_aws_config() {
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "AWS CLI no está configurado. Por favor configura tus credenciales primero."
        exit 1
    fi
}

create_backend() {
    log_info "Creando recursos para el backend de Terraform..."
    
    log_info "Creando bucket S3: $BUCKET_NAME"
    if aws s3 ls "s3://$BUCKET_NAME" &> /dev/null; then
        log_warn "El bucket S3 $BUCKET_NAME ya existe"
    else
        aws s3 mb "s3://$BUCKET_NAME" --region $REGION
        log_info "Bucket S3 creado exitosamente"
    fi

    log_info "Habilitando versionado en el bucket S3"
    aws s3api put-bucket-versioning \
        --bucket $BUCKET_NAME \
        --versioning-configuration Status=Enabled

    log_info "Habilitando encriptación en el bucket S3"
    aws s3api put-bucket-encryption \
        --bucket $BUCKET_NAME \
        --server-side-encryption-configuration '{
            "Rules": [
                {
                    "ApplyServerSideEncryptionByDefault": {
                        "SSEAlgorithm": "AES256"
                    }
                }
            ]
        }'

    log_info "Bloqueando acceso público al bucket S3"
    aws s3api put-public-access-block \
        --bucket $BUCKET_NAME \
        --public-access-block-configuration \
        "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

    log_info "Creando tabla DynamoDB: $TABLE_NAME"
    if aws dynamodb describe-table --table-name $TABLE_NAME --region $REGION &> /dev/null; then
        log_warn "La tabla DynamoDB $TABLE_NAME ya existe"
    else
        aws dynamodb create-table \
            --table-name $TABLE_NAME \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --billing-mode PAY_PER_REQUEST \
            --region $REGION
        
        log_info "Esperando a que la tabla DynamoDB esté activa..."
        aws dynamodb wait table-exists --table-name $TABLE_NAME --region $REGION
        log_info "Tabla DynamoDB creada exitosamente"
    fi

    if [ ! -f "$BACKEND_TF_FILE" ]; then
        log_info "Creando archivo $BACKEND_TF_FILE"
        cat > $BACKEND_TF_FILE << EOF
terraform {
  backend "s3" {
    bucket             = "$BUCKET_NAME"
    key                = "terraform.tfstate"
    region             = "$REGION"
    encrypt            = true
    dynamodb_table     = "$TABLE_NAME"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "$REGION"
}
EOF
    else
        log_warn "El archivo $BACKEND_TF_FILE ya existe"
    fi

    log_info "✅ Backend de Terraform configurado exitosamente!"
    log_info "   - Bucket S3: $BUCKET_NAME"
    log_info "   - Tabla DynamoDB: $TABLE_NAME"
    log_info "   - Archivo backend.tf: Creado/Verificado"
}

delete_backend() {
    log_warn "Esta acción eliminará permanentemente el backend de Terraform"
    read -p "¿Estás seguro? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        log_info "Operación cancelada"
        exit 0
    fi

    log_info "Eliminando recursos del backend de Terraform..."
    
    log_info "Eliminando bucket S3: $BUCKET_NAME"
    if aws s3 ls "s3://$BUCKET_NAME" &> /dev/null; then
        log_info "Deshabilitando versionado para el bucket $BUCKET_NAME..."
        aws s3api put-bucket-versioning \
            --bucket $BUCKET_NAME \
            --versioning-configuration Status=Suspended

        log_info "Eliminando todas las versiones de objetos y marcadores de eliminación en $BUCKET_NAME..."
        aws s3api list-object-versions --bucket $BUCKET_NAME \
            --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json | \
            jq -c '.[]' | while read -r object; do
                KEY=$(echo "$object" | jq -r '.Key')
                VERSION_ID=$(echo "$object" | jq -r '.VersionId')
                log_info "  Eliminando version: Key=$KEY, VersionId=$VERSION_ID"
                aws s3api delete-object --bucket $BUCKET_NAME --key "$KEY" --version-id "$VERSION_ID"
            done

        aws s3api list-object-versions --bucket $BUCKET_NAME \
            --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json | \
            jq -c '.[]' | while read -r object; do
                KEY=$(echo "$object" | jq -r '.Key')
                VERSION_ID=$(echo "$object" | jq -r '.VersionId')
                log_info "  Eliminando marcador de eliminación: Key=$KEY, VersionId=$VERSION_ID"
                aws s3api delete-object --bucket $BUCKET_NAME --key "$KEY" --version-id "$VERSION_ID"
            done

        aws s3 rb "s3://$BUCKET_NAME" --force
        log_info "Bucket S3 eliminado exitosamente"
    else
        log_warn "El bucket S3 $BUCKET_NAME no existe"
    fi

    log_info "Eliminando tabla DynamoDB: $TABLE_NAME"
    if aws dynamodb describe-table --table-name $TABLE_NAME --region $REGION &> /dev/null; then
        aws dynamodb delete-table --table-name $TABLE_NAME --region $REGION
        log_info "Tabla DynamoDB eliminada exitosamente"
    else
        log_warn "La tabla DynamoDB $TABLE_NAME no existe"
    fi

    read -p "¿Deseas eliminar el archivo backend.tf? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]] && [ -f "$BACKEND_TF_FILE" ]; then
        rm $BACKEND_TF_FILE
        log_info "Archivo $BACKEND_TF_FILE eliminado"
    fi

    log_info "✅ Backend de Terraform eliminado exitosamente!"
}

status_backend() {
    log_info "Verificando estado del backend..."
    
    if aws s3 ls "s3://$BUCKET_NAME" &> /dev/null; then
        log_info "✅ Bucket S3 $BUCKET_NAME: EXISTE"
        
        VERSIONING=$(aws s3api get-bucket-versioning --bucket $BUCKET_NAME --query Status --output text 2>/dev/null || echo "Disabled")
        log_info "   Versionado: $VERSIONING"
    else
        log_info "❌ Bucket S3 $BUCKET_NAME: NO EXISTE"
    fi

    if aws dynamodb describe-table --table-name $TABLE_NAME --region $REGION &> /dev/null; then
        log_info "✅ Tabla DynamoDB $TABLE_NAME: EXISTE"
        
        TABLE_STATUS=$(aws dynamodb describe-table --table-name $TABLE_NAME --region $REGION --query Table.TableStatus --output text)
        log_info "   Estado: $TABLE_STATUS"
    else
        log_info "❌ Tabla DynamoDB $TABLE_NAME: NO EXISTE"
    fi

    if [ -f "$BACKEND_TF_FILE" ]; then
        log_info "✅ Archivo $BACKEND_TF_FILE: EXISTE"
    else
        log_info "❌ Archivo $BACKEND_TF_FILE: NO EXISTE"
    fi

    if [ -f "$MAIN_TF_FILE" ]; then
        log_info "✅ Archivo $MAIN_TF_FILE: EXISTE"
    else
        log_info "❌ Archivo $MAIN_TF_FILE: NO EXISTE"
    fi
}

show_help() {
    echo "Uso: $0 {create|delete|status|help}"
    echo ""
    echo "Comandos:"
    echo "  create  - Crear el backend S3 y DynamoDB para Terraform"
    echo "  delete  - Eliminar el backend S3 y DynamoDB"
    echo "  status  - Mostrar el estado actual del backend"
    echo "  help    - Mostrar esta ayuda"
    echo ""
    echo "Recursos que se crean:"
    echo "  - Bucket S3: $BUCKET_NAME"
    echo "  - Tabla DynamoDB: $TABLE_NAME"
    echo "  - Archivo: $BACKEND_TF_FILE"
}

check_aws_config

case "$1" in
    create)
        create_backend
        ;;
    delete)
        delete_backend
        ;;
    status)
        status_backend
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_error "Comando no válido: $1"
        echo ""
        show_help
        exit 1
        ;;
esac