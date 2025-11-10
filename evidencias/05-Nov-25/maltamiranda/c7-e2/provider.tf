// ----------------------------------------------------------------------
// Bloque del Proveedor (Configuración de Credenciales/Región)
// ----------------------------------------------------------------------
provider "aws" {
  region = var.aws_region
  profile = "251964342273_FreeTierAccess" // este es el perfil que tengas en ~/.aws/credentials
  // Asume que las credenciales están configuradas vía variables de entorno o AWS CLI profile
}
