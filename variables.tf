# Talos
variable "talos_version" {
  type    = string
  default = "v1.11.2"
}
variable "cluster_name" {
  type    = string
  default = "talos-cluster"
}
variable "kubernetes_version" {
  type    = string
  default = "v1.34.1"
}

variable "cluster_endpoint" {
  description = "The endpoint for the control plane."
  type        = string
  default     = "10.0.0.250"
}

variable "control_plane_instances" {
  description = "A list of instances that will be used as control plane nodes."
  type = list(object({
    name       = string
    private_ip = string
    public_ip  = string
  }))
  default = [
    {
      name       = "talos01"
      private_ip = "10.0.0.249"
      public_ip  = "10.0.0.249"
    },
    {
      name       = "talos02"
      private_ip = "10.0.0.241"
      public_ip  = "10.0.0.241"
    },
    {
      name       = "talos03"
      private_ip = "10.0.0.248"
      public_ip  = "10.0.0.248"
    }
  ]
}

variable "worker_instances" {
  description = "A list of instances that will be used as worker nodes."
  type = list(object({
    name       = string
    private_ip = string
    public_ip  = string
  }))
  default = [
    {
      name       = "worker01"
      private_ip = "10.0.0.253"
      public_ip  = "10.0.0.253"
    },
  ]
}
