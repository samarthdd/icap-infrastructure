# RabbitMQ operator 

The below is a guide to standing up the Rabbitmq-Operator to work within AKS.

### Install RabbitMQ Cluster Operator

The below command will install the operator for you:

```bash
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
```

Once this has been created, you can then install the service via helm or argocd

Helm
```bash
helm install ./rabbit -n icap-adaptation --generate-name
```
Argocd
```bash
argocd app create rabbitmq-service-main --repo https://github.com/filetrust/icap-infrastructure --path rabbitmq --dest-server https://gw-icap-k8s-f17703a9.hcp.uksouth.azmk8s.io:443 --dest-namespace icap-adaptation --revision main
```

Once installed you will need to get the admin credentials from the cluster itself, use the following commands:

```bash
kubectlA n icap-adaptation get secret rabbitmq-service-default-user -o jsonpath="{.data.username}" | base64 --decode

kubectlA n icap-adaptation get secret rabbitmq-service-default-user -o jsonpath="{.data.password}" | base64 --decode
```

These admin credentials then need to be added to the adaptation service values, please see example below:

```yaml
queue:
  messagebrokeruser: "<admin creds>"
  messagebrokerpassword: "<admin creds>"
  host:
    url: "rabbitmq-service"
    port: "\"5672\""
```

