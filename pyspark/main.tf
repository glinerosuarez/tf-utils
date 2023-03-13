terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "pyspark" {
  name = "pyspark"
  keep_locally = false
  build {
    context = path.module
  }
  triggers = {
    docker_file_sha1 = filesha1("${path.module}/Dockerfile")
  }
}

resource "docker_container" "pyspark" {
  image = docker_image.pyspark.image_id
  name  = "pyspark"
  tty = true
  command = ["python"]
  must_run = false
  ports {
    internal = 4040
    external = 4040
  }
}