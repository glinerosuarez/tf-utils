terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "pyspark" {
  name         = "apache/spark-py"
  keep_locally = false
}

resource "docker_container" "pyspark" {
  image = docker_image.pyspark.image_id
  name  = "pyspark"
  tty = true
  command = ["/opt/spark/bin/pyspark"]
  stdin_open = true
  must_run = false
}