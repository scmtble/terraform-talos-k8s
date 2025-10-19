resource "helm_release" "cilium" {
  name      = "cilium"
  namespace = "kube-system"

  repository       = "https://helm.cilium.io/"
  chart            = "cilium"
  description      = "Cilium CNI"
  version          = "1.18.2"
  create_namespace = false
  max_history      = 3

  values = [yamlencode({
    autoDirectNodeRoutes = true
    bpf = {
      datapathMode = "netkit"
      masquerade   = true
    }
    cgroup = {
      autoMount = {
        enabled = false
      }
      hostRoot = "/sys/fs/cgroup"
    }
    enableIPv4Masquerade = true
    endpointRoutes = {
      enabled = true
    }
    envoy = {
      resources = {
        limits = {
          cpu    = "100m"
          memory = "256Mi"
        }
        requests = {
          cpu    = "0"
          memory = "0"
        }
      }
    }
    envoyConfig = {
      enabled = true
    }
    hubble = {
      relay = {
        enabled = true
      }
      ui = {
        enabled = true
      }
    }
    ipam = {
      mode = "kubernetes"
    }
    ipv4NativeRoutingCIDR = "10.244.0.0/16"
    k8sServiceHost        = "10.0.0.250"
    k8sServicePort        = 6443
    kubeProxyReplacement  = true
    loadBalancer = {
      l7 = {
        backend = "envoy"
      }
    }
    operator = {
      resources = {
        limits = {
          cpu    = "100m"
          memory = "256Mi"
        }
        requests = {
          cpu    = "0"
          memory = "0"
        }
      }
    }
    resources = {
      limits = {
        cpu    = "500m"
        memory = "1Gi"
      }
      requests = {
        cpu    = "100m"
        memory = "256Mi"
      }
    }
    routingMode = "native"
    securityContext = {
      capabilities = {
        ciliumAgent      = ["CHOWN", "KILL", "NET_ADMIN", "NET_RAW", "IPC_LOCK", "SYS_ADMIN", "SYS_RESOURCE", "DAC_OVERRIDE", "FOWNER", "SETGID", "SETUID"]
        cleanCiliumState = ["NET_ADMIN", "SYS_ADMIN", "SYS_RESOURCE"]
      }
    }
  })]
}
