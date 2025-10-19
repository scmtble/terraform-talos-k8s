# talosconfig
data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for instance in var.control_plane_instances : instance.public_ip]
}

resource "local_sensitive_file" "talosconfig" {
  content  = data.talos_client_configuration.this.talos_config
  filename = "${path.module}/talosconfig"
}

# kubeconfig
resource "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this
  ]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.control_plane_instances[0].private_ip
  endpoint             = var.control_plane_instances[0].public_ip
}

resource "local_sensitive_file" "kubeconfig" {
  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename = "${path.module}/kubeconfig.yaml"
}

