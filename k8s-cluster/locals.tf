locals {
  volumes = [
    {
      host_path      = "/"
      container_path = "/rootfs"
      read_only      = true
    },
    {
      host_path      = "/sys"
      container_path = "/sys"
      read_only      = true
    },
    {
      host_path      = "/dev"
      container_path = "/dev"
      read_only      = false
    },
    {
      host_path      = "/var/lib/docker"
      container_path = "/var/lib/docker"
      read_only      = true
    },
    {
      host_path      = "/var/lib/kubelet/"
      container_path = "/var/lib/kubelet/"
      read_only      = false
    },
    {
      host_path      = "/var/run"
      container_path = "/var/run"
      read_only      = false
    },
  ]
}