terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "mysql" {
  name         = "mysql"
  keep_locally = false
}

resource "docker_volume" "db" {
  name = "mysql-db-volume"
}

resource "docker_container" "mysql" {
  image   = docker_image.mysql.image_id
  name    = "db"
  env     = ["MYSQL_ROOT_PASSWORD=${var.root_password}", "MYSQL_DATABASE=${var.db_name}"]
  restart = "always"

  ports {
    internal = 3306
    external = 3306
  }

  volumes {
    host_path      = abspath(var.init_queries_path == null ? path.module : var.init_queries_path)
    container_path = "/docker-entrypoint-initdb.d"
  }

  healthcheck {
    test     = ["CMD", "mysqladmin", "ping", "-u", "root", "-p${var.root_password}"]
    interval = "5s"
    retries  = 5
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/healthy_check.sh ${self.name}"
  }
}