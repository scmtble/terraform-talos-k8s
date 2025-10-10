# resource "local_sensitive_file" "talos_cluster_control_plane" {
#   content  = yamlencode(data.talos_machine_configuration.control_plane)
#   filename = "${path.module}/tmp/talos-cluster-control_plane.yaml"
# }

# resource "local_sensitive_file" "machine_secrets_yaml" {
#   content  = yamlencode(talos_machine_secrets.this.machine_secrets)
#   filename = "${path.module}/tmp/talos-machine-secrets.yaml"
# }

resource "local_sensitive_file" "talosconfig" {
  content  = data.talos_client_configuration.this.talos_config
  filename = "${path.module}/talosconfig"
}

resource "local_sensitive_file" "talos_cluster_kubeconfig" {
  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename = "${path.module}/kubeconfig.yaml"
}

