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
  image = docker_image.postgres.image_id
  name  = "db"
  env   = ["POSTGRES_USER=${var.user}", "POSTGRES_PASSWORD=${var.password}", "POSTGRES_DB=${var.db_name}"]
  volumes {
    volume_name    = docker_volume.db.name
    container_path = "/var/lib/postgresql/data"
  }
  healthcheck {
    test     = ["CMD", "pg_isready", "-U", "postgres"]
    interval = "5s"
    retries  = 5
  }
  restart = "always"

  provisioner "local-exec" {
    command = "bash ${path.root}/healthy_check.sh ${self.name}"
  }
}