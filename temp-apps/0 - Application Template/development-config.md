apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: <application-name>
  namespace: <argocd-namespace>
spec:
  source:
    repoURL: <helm-repository-url>
    chart: <chart-name>
    targetRevision: <chart-version>
  destination:
    server: https://kubernetes.default.svc
    namespace: <target-namespace>

# Applications from apps.md
app-name: actualbudget
app-environment: development
app-chart: community-charts/actualbudget
app-repoUrl: https://community-charts.github.io/helm-charts
app-version: 1.4.2
namespace: default

app-name: kube-prometheus-stack
app-environment: development
app-chart: prometheus-community/kube-prometheus-stack
app-repoUrl: https://prometheus-community.github.io/helm-charts
app-version: 70.4.1
namespace: default

app-name: argo-cd
app-environment: development
app-chart: argo/argo-cd
app-repoUrl: https://argoproj.github.io/argo-helm
app-version: 7.8.23
namespace: default

app-name: traefik
app-environment: development
app-chart: traefik/traefik
app-repoUrl: https://traefik.github.io/charts
app-version: 34.5.0
namespace: default

app-name: keycloak
app-environment: development
app-chart: bitnami/keycloak
app-repoUrl: https://charts.bitnami.com/bitnami
app-version: 24.5.0
namespace: default

app-name: loki
app-environment: development
app-chart: grafana/loki
app-repoUrl: https://grafana.github.io/helm-charts
app-version: 6.29.0
namespace: default

app-name: openproject
app-environment: development
app-chart: openproject-helm-charts/openproject
app-repoUrl: https://charts.openproject.org
app-version: 9.8.3
namespace: default

app-name: postgresql
app-environment: development
app-chart: bitnami/postgresql
app-repoUrl: https://charts.bitnami.com/bitnami
app-version: 16.6.0
namespace: default

app-name: redis
app-environment: development
app-chart: bitnami/redis
app-repoUrl: https://charts.bitnami.com/bitnami
app-version: 20.11.4
namespace: default
