resource "random_password" "random_string" {
  count       = 2 # Количество паролей
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql" {
  name         = "mysql:8.0"
  keep_locally = true
}

resource "docker_container" "mysql8" {
  image = docker_image.mysql.image_id
  name  = "mysql8"
  ports {
    internal = 3306
    external = 3306
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.random_string[0].result}",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.random_string[1].result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_ROOT_HOST=%"
  ]
}
