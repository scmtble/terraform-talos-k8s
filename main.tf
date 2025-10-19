module "talos" {
  source = "./talos"
}

module "k8s" {
  source                   = "./k8s"
  kubernetes_client_config = module.talos.kubernetes_client_config
}
