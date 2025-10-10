```bash
helm upgrade \
    cilium \
    cilium/cilium \
    --version 1.18.1 \
    --namespace kube-system \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=true \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
    --set k8sServiceHost=localhost \
    --set k8sServicePort=7445 \
    --set bpf.datapathMode=netkit \
    --set bpf.masquerade=true \
    --set bpf.hostLegacyRouting=true \
    --set autoDirectNodeRoutes=true \
    --set routingMode=native \
    --set ipv4NativeRoutingCIDR=10.244.0.0/16 \
    --set directRoutingSkipUnreachable=true \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true
```

```bash
helm install cilium cilium/cilium --version 1.18.1 --namespace kube-system --set ipam.mode=kubernetes --set kubeProxyReplacement=true --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" --set cgroup.autoMount.enabled=false --set cgroup.hostRoot=/sys/fs/cgroup --set k8sServiceHost=localhost --set k8sServicePort=7445 --set bpf.datapathMode=netkit --set bpf.masquerade=true --set bpf.hostLegacyRouting=true --set autoDirectNodeRoutes=true --set routingMode=native --set ipv4NativeRoutingCIDR=10.244.0.0/16 --set hubble.relay.enabled=true --set hubble.ui.enabled=true
```