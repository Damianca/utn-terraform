terraform {
  required_version = ">= 1.4.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Provider Docker 
provider "docker" {
  # host = "unix:///var/run/docker.sock"             # Linux/macOS (por defecto suele funcionar sin especificar)
  # host = "npipe:////./pipe/dockerDesktopLinuxEngine" # Windows (Docker Desktop)
}

# Red dedicada (opcional, pero buena práctica)
resource "docker_network" "web_net" {
  name   = "tf_web_net"
  driver = "bridge"
}

# Imagen de Nginx (alpine, ligera)
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

# Contenedor Nginx sirviendo /site (bind mount) y exponiendo 8080->80
resource "docker_container" "nginx" {
  name  = "tf-nginx"
  image = docker_image.nginx.image_id
  networks_advanced {
    name = docker_network.web_net.name
  }

  # Mapea puerto host 8080 al 80 del contenedor
  ports {
    internal = 80
    external = 8080
  }

  # Monta la carpeta local ./site al docroot de Nginx
  mounts {
    target = "/usr/share/nginx/html"
    type   = "bind"
    source = "/home/dcanovas/Documentos/per/training/tf/clases/clase_01/ejercicio_03/site" 
    #"${path.module}/site"
    read_only = true
  }

  # Política de reinicio (opcional)
  restart = "unless-stopped"
}

# Salidas útiles
output "container_id" {
  value = docker_container.nginx.id
}

output "url" {
  value = "http://localhost:8080"
}
