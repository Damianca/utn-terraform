Prueba para asegurarte de que funciona

Una vez creado, sube un archivo al bucket:

echo "Hola KMS STRIX" > prueba1.txt
aws s3 cp prueba1.txt s3://$(terraform output -raw s3_bucket_name)/

Verifica que está cifrado con KMS:
aws s3api head-object \
  --bucket $(terraform output -raw s3_bucket_name) \
  --key prueba.txt \
  --query 'ServerSideEncryption'

Resultado esperado:
"aws:kms"

Y para ver la clave usada:

aws s3api head-object \
  --bucket $(terraform output -raw s3_bucket_name) \
  --key prueba.txt \
  --query 'SSEKMSKeyId'

Para eliminar al finalizar deberás vaciar el bucket

BUCKET=$(terraform output -raw s3_bucket_name)
aws s3 rm s3://$BUCKET --recursive --region us-east-1

terraform destroy
