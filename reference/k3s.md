# Startup Features

## Auto-Deploying Manifests & User Addons

Path on host: /var/lib/rancher/k3s/server/manifests
Path in repo: /manifests/server-manifests
AddOn name: 
- file basename
- Lowercase letters, numbers, -, and . only (RFC 1123 DNS)

Mannifest apply conditions:
- Startup of a k3s server node
- When the file is modified on the host

Namespace & Behaviour:
- Managed as AddOn CRs in the kube-system namespace
    - kubectl describe addon <name> -n kube-system
    - kubectl get events -n kube-system
- Manifests are overwritten on K3s startup
- No automated manifest sync between server nodes

## Helm 
- K3s includes Helm Controller via. HelmChart CRD
- Overide the defaults with HelmChartConfig resource
    - must match namespace
    - must match name

Chart feilds
- https://docs.k3s.io/helm#customizing-packaged-components-with-helmchartconfig
metadata.name
spec.chart
spec.targetNamespace (default: default)
spec.createNamespace (default: false)
spec.version
spec.repo
spec.repoCA
spec.repoCAConfigMap
spec.helmVersion (default: v3)
spec.bootstrap (default: false)
spec.set
spec.jobImage
spec.backOffLimit (default: 1000)
spec.timeout (default: 300s)
spec.failurePolicy (default: reinstall)
spec.authSecret
spec.authPassCredentials (default: false)
spec.dockerRegistrySecret
spec.valuesContent
spec.chartContent


## Startup Apps 

Automatically deployed via manifests:
- coredns, traefik, local-storage, metrics-server
- servicelb is managed internally (not file-based)

K3s Default Manifests: ./k3s-default-manifests/
Manifest Location: /var/lib/rancher/k3s/server/manifests/
Customize Via: /var/lib/rancher/k3s/server/manifests/app-config.yaml using HelmChartConfig.

Startup Behaviour: K3s automaticaly writes default manifest files if none are present.

### Traefik Ingress Controller
- Ports: 80 (HTTP), 443 (HTTPS)
- Service type: LoadBalancer
- Ingress status IPs reflect all node IPs by default.

### CoreDNS
### Network Policy Controller
### Cloud Controller Manager
K3s includes an embedded CCM stub.
Functions:
    Sets node InternalIP / ExternalIP
    Hosts ServiceLB controller
    Clears node.cloudprovider.kubernetes.io/uninitialized taint

### ServiceLB

Watches: Services with type: LoadBalancer.
Mechanism: Spawns DaemonSet pods per node (svc- prefix), using hostPort.
External IP resolution:
- Uses node external IP if present.
- Falls back to internal IP if not.
