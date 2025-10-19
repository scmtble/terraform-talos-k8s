resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version

  lifecycle {
    prevent_destroy = true
  }
}
