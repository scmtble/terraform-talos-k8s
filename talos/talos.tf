data "talos_machine_configuration" "control_plane" {
  for_each = { for instance in var.control_plane_instances : instance.name => instance }

  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${var.cluster_endpoint}:6443"
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  docs               = false
  examples           = false

  config_patches = [
    yamlencode({
      machine : {
        certSANs : sort(
          distinct(
            compact(
              concat(
                [for instance in var.control_plane_instances : instance.private_ip],
                ["127.0.0.1", "::1", "localhost"],
                ["${var.cluster_endpoint}"],
              )
            )
          )
        )
        network : {
          hostname : "ip-${replace(each.value.private_ip, ".", "-")}.cn-wuhan-1.compute.internal"
          interfaces : [
            {
              interface : "ens18"
              addresses : [
                "${each.value.private_ip}/24"
              ],
              routes : [
                {
                  network : "0.0.0.0/0"
                  gateway : "10.0.0.1"
                  metric : 1024
                  mtu : 1500
                }
              ],
              dhcp : false
            }
          ],
          nameservers : ["10.0.0.1"]
        }
        kubelet : {
          defaultRuntimeSeccompProfileEnabled : true
          disableManifestsDirectory : true
          registerWithFQDN : true
          extraArgs : {
            # "cloud-provider" : "external"
            "rotate-server-certificates" : true
          }
        }
        features : {
          kubernetesTalosAPIAccess : {
            enabled : true
            allowedRoles : ["os:reader"]
            allowedKubernetesNamespaces : ["kube-system"]
          }
        }
        # 设置镜像源
        registries : {
          mirrors : {
            "docker.io" : {
              endpoints : ["https://docker.m.daocloud.io"]
            }
            "gcr.io" : {
              endpoints : ["https://gcr.m.daocloud.io"]
            }
            "ghcr.io" : {
              endpoints : ["https://ghcr.m.daocloud.io"]
            }
            "registry.k8s.io" : {
              endpoints : ["https://k8s.m.daocloud.io"]
            }
          }
        }
        install : {
          disk : "/dev/sda"
          image : "ghcr.io/siderolabs/installer:v1.11.2"
          wipe : false
        }
        features : {
          hostDNS : {
            enabled              = true
            forwardKubeDNSToHost = false
            resolveMemberNames   = true
          }
        }
      },
      cluster : {
        apiServer : {
          certSANs : sort(
            distinct(
              compact(
                concat(
                  [for instance in var.control_plane_instances : instance.private_ip],
                  ["127.0.0.1", "::1", "localhost"],
                  ["${var.cluster_endpoint}"],
                )
              )
            )
          )
        }
        discovery : {
          enabled : false
        }
        etcd : {
          # advertisedSubnets : ["10.0.0.0/24"]
          extraArgs = {
            "listen-metrics-urls" = "http://0.0.0.0:2381"
          }
        }
        network : {
          cni : {
            name : "none"
          }
        }
        proxy : {
          disabled : true
        }
        allowSchedulingOnControlPlanes : true
      }
    }),
    yamlencode({
      # local-storage.yaml
      apiVersion = "v1alpha1"
      kind       = "UserVolumeConfig"
      name       = "local-storage"
      provisioning = {
        diskSelector = {
          match : "disk.model == 'QEMU HARDDISK'"
        }
        minSize = "1GB"
        maxSize = "1GB"
        grow    = true
      }
    })
  ]
}

data "talos_machine_configuration" "worker" {
  for_each = { for instance in var.worker_instances : instance.name => instance }

  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${var.cluster_endpoint}:6443"
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  docs               = false
  examples           = false

  config_patches = [
    yamlencode({
      machine : {
        certSANs : sort(
          distinct(
            compact(
              concat(
                [for instance in var.control_plane_instances : instance.private_ip],
                ["127.0.0.1", "::1", "localhost"],
                ["${var.cluster_endpoint}"],
              )
            )
          )
        )
        network : {
          hostname : "ip-${replace(each.value.private_ip, ".", "-")}.cn-wuhan-1.compute.internal"
          interfaces : [
            {
              interface : "ens18"
              addresses : [
                "${each.value.private_ip}/24"
              ],
              routes : [
                {
                  network : "0.0.0.0/0"
                  gateway : "10.0.0.1"
                  metric : 1024
                  mtu : 1500
                }
              ],
              dhcp : false
            }
          ],
          nameservers : ["10.0.0.1"]
        }

        kubelet : {
          defaultRuntimeSeccompProfileEnabled : true
          disableManifestsDirectory : true
          registerWithFQDN : true
          extraArgs : {
            # "cloud-provider" : "external"
            "rotate-server-certificates" : true
          }
        }
        features : {
          kubernetesTalosAPIAccess : {
            enabled : true
            allowedRoles : ["os:reader"]
            allowedKubernetesNamespaces : ["kube-system"]
          }
        }
        # 设置镜像源
        registries : {
          mirrors : {
            "docker.io" : {
              endpoints : ["https://docker.m.daocloud.io"]
            }
            "gcr.io" : {
              endpoints : ["https://gcr.m.daocloud.io"]
            }
            "ghcr.io" : {
              endpoints : ["https://ghcr.m.daocloud.io"]
            }
            "registry.k8s.io" : {
              endpoints : ["https://k8s.m.daocloud.io"]
            }
          }
        }
        install : {
          disk : "/dev/sda"
          image : "ccr.ccs.tencentyun.com/scmtble/installer:v1.11.0"
          wipe : false
        }
        features : {
          hostDNS : {
            enabled              = true
            forwardKubeDNSToHost = false
            resolveMemberNames   = true
          }
        }
      },
      cluster : {
        apiServer : {
          certSANs : sort(
            distinct(
              compact(
                concat(
                  [for instance in var.control_plane_instances : instance.private_ip],
                  ["127.0.0.1", "::1", "localhost"],
                  ["${var.cluster_endpoint}"],
                )
              )
            )
          )
        }
        discovery : {
          enabled : false
        }
        network : {
          cni : {
            name : "none"
          }
        }
        proxy : {
          disabled : true
        }
        allowSchedulingOnControlPlanes : true
      }
    }),
    yamlencode({
      # local-storage.yaml
      apiVersion = "v1alpha1"
      kind       = "UserVolumeConfig"
      name       = "local-storage"
      provisioning = {
        diskSelector = {
          match : "disk.model == 'QEMU HARDDISK'"
        }
        minSize = "1GB"
        maxSize = "1GB"
        grow    = true
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "control_plane" {
  for_each = { for instance in var.control_plane_instances : instance.name => instance }

  on_destroy = {
    graceful = false
    reboot   = false
    reset    = true
  }

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane[each.key].machine_configuration
  endpoint                    = each.value.public_ip
  node                        = each.value.private_ip
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = { for instance in var.worker_instances : instance.name => instance }

  on_destroy = {
    graceful = false
    reboot   = false
    reset    = true
  }

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[each.key].machine_configuration
  endpoint                    = each.value.public_ip
  node                        = each.value.private_ip
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = var.control_plane_instances[0].public_ip
  node                 = var.control_plane_instances[0].private_ip

  depends_on = [
    talos_machine_configuration_apply.control_plane
  ]
}
