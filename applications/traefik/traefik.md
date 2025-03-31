It is neccessary to add .skip so that when copied in to the /manifests on k3s install it will not be applied.

Values.yaml
- creates:
  - deployment
  - pod
  - service - load balancer
  - ingressClass
  - gatewayClass
  - pod distrobution budget
  - configmap
  - secrets
  - providers.file??
  - horizontal pod autoscaler
  - persistant volume
  - 
