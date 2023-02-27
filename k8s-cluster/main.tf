resource "docker_image" "etcd" {
  name         = "gcr.io/google_containers/etcd:2.0.12"
  keep_locally = false
}

resource "docker_image" "hyperkube" {
  name         = "gcr.io/google_containers/hyperkube:v1.1.3"
  keep_locally = false
}

resource "docker_container" "etcd" {
  image        = docker_image.etcd.image_id
  name         = "etcd"
  command      = ["/usr/local/bin/etcd", "--addr=127.0.0.1:4001", "--bind-addr=0.0.0.0:4001", "--data-dir=/var/etcd/data"]
  network_mode = "host"
}

resource "docker_container" "master" {
  image = docker_image.hyperkube.image_id
  name  = "master"
  must_run = true
  command = [
    "/hyperkube",
    "kubelet",
    "--containerized",
    "--hostname-override=127.0.0.1",
    "--address=0.0.0.0",
    "--api-servers=http://localhost:8080",
    "--config=/etc/kubernetes/manifests"
  ]
  network_mode = "host"
  pid_mode     = "host"
  privileged   = true
  dynamic "volumes" {
    for_each = local.volumes
    iterator = v
    content {
      host_path      = v.value.host_path
      container_path = v.value.container_path
      read_only      = v.value.read_only
    }
  }
}

