metadata:
  name: my-app-pod
  labels:
    app: my-app
    env: production
    version: v1

apiVersion: v1
kind: Pod
metadata:
  name: my-app-pod
  annotations:
    description: "This pod runs my main application"
    gitCommit: "f6a35a4"
    monitoring.example.com/enabled: "true"

https://docs.google.com/document/d/13agmoyF4qDV-b8cqI4pn--fiZnUt4lnLtd0nYNbvB1M/edit?tab=t.0