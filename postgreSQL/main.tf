terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "postgres" {
  name         = "postgres:14"
  keep_locally = false
}

resource "docker_volume" "db" {
  name = "postgres-db-volume"
}

resource "docker_container" "postgres" {
  image   = docker_image.postgres.image_id
  name    = "db"
  env     = ["POSTGRES_USER=${var.user}", "POSTGRES_PASSWORD=${var.password}", "POSTGRES_DB=${var.db_name}"]
  restart = "always"

  volumes {
    volume_name    = docker_volume.db.name
    container_path = "/var/lib/postgresql/data"
  }
  volumes {
    host_path      = var.init_queries_path == null ? path.module : var.init_queries_path
    container_path = "/docker-entrypoint-initdb.d"
  }

  healthcheck {
    test     = ["CMD", "pg_isready", "-U", "postgres"]
    interval = "5s"
    retries  = 5
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/healthy_check.sh ${self.name}"
  }
}