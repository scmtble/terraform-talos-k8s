resource "helm_release" "metrics-server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository       = "https://kubernetes-sigs.github.io/metrics-server"
  chart            = "metrics-server"
  description      = "Metrics Server"
  version          = "3.13.0"
  create_namespace = false
  max_history      = 3

  values = [
    yamlencode({
      replicas = 2
    })
  ]
}
