variable "image_mirrors" {
  type = map(object({
    endpoints : list(string)
  }))
  default = {
    "docker.io" = {
      endpoints = ["https://docker.m.daocloud.io"]
    }
    "gcr.io" = {
      endpoints = ["https://gcr.m.daocloud.io"]
    }
    "ghcr.io" = {
      endpoints = ["https://ghcr.m.daocloud.io"]
    }
    "registry.k8s.io" = {
      endpoints = ["https://k8s.m.daocloud.io"]
    }
  }
}
