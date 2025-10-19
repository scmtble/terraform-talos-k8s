locals {
  certSANs = sort(
    distinct(
      compact(
        concat(
          [for instance in var.control_plane_instances : instance.private_ip],
          [for instance in var.control_plane_instances : instance.public_ip],
          ["127.0.0.1", "::1", "localhost"],
          ["${var.cluster_endpoint}"],
        )
      )
    )
  )
}
