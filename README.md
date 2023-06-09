# Elastic search stack

## Elastic search 7.17.3

### Prerequisites

1. Install k3s and helm

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install git zsh curl -y

# Install k3s
curl -sfL https://get.k3s.io | sh - 

# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh
```

2. Install nginx ingress controller:

```bash
sudo k3s kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0/deploy/static/provider/cloud/deploy.yaml
``` 

### Install

1. Download [https://github.com/elastic/helm-charts/releases/tag/v7.17.3]
1. Unpack it: `tar -zxvf elastic-7.17.3.tgz`
1. Create namespace: `kubectl create namespace elasticsearch`
1. Install chart: `helm upgrade elasticsearch-release helm-charts-7.17.3/elasticsearch/ --namespace elasticsearch`
1. Change `values.yaml`. Most important changes can be seen below:

    ```yaml
    replicas: 1
    minimumMasterNodes: 1

    image: "docker.elastic.co/elasticsearch/elasticsearch"
    imageTag: "7.17.3"
    imagePullPolicy: "IfNotPresent"

    networkHost: "0.0.0.0"

    protocol: http
    httpPort: 9200
    transportPort: 9300

    service:
    enabled: true
    labels: {}
    labelsHeadless: {}
    type: LoadBalancer
    # Consider that all endpoints are considered "ready" even if the Pods themselves are not
    # https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec
    publishNotReadyAddresses: false
    nodePort: ""
    annotations: {}
    httpPortName: http
    transportPortName: transport
    loadBalancerIP: 192.168.50.250 # Set your desired IP address here
    loadBalancerSourceRanges: []
    externalTrafficPolicy: ""

    ingress:
    enabled: true
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
    className: "nginx"
    pathtype: ImplementationSpecific
    hosts:
      - host: elastic.local
        paths:
          - path: /
    rules:
      - host: "192.168.50.250"
        http:
          paths:
            - path: /
              backend:
                serviceName: elasticsearch-master
                servicePort: http
    tls: []
    ```

> Note about ingress: The IP should point to where the k3s cluster is hosted, do a `ifconfig` from the kubernetes host machine.
> Note about ingress DNS: To resolve `elastic.local`, this must be added to `/etc/hosts/` as `192.168.50.250 elastic.local`. 

1. Run helm chart `helm upgrade --install my-release . --namespace elastic -f values.yaml`

## Kibana

1. Download [https://github.com/elastic/helm-charts/releases/tag/v7.17.3]
1. Unpack it: `tar -zxvf elastic-7.17.3.tgz`
1. Create namespace: `kubectl create namespace kibana`
1. Install chart: `helm upgrade kibana-release helm-charts-7.17.3/kibana/ --namespace kibana`
1. Change `values.yaml`. Most important changes can be seen below:

## Filebeat

1. Download [https://github.com/elastic/helm-charts/releases/tag/v7.17.3]
1. Unpack it: `tar -zxvf elastic-7.17.3.tgz`
1. Create namespace: `kubectl create namespace filebeat`
1. Install chart: `helm install filebeat-release helm-charts-7.17.3/filebeat/ --namespace filebeat`
1. Upgrade chart: `helm upgrade filebeat-release helm-charts-7.17.3/filebeat/ --namespace filebeat`
1. Change `values.yaml`.

## Metricbeat

1. Download [https://github.com/elastic/helm-charts/releases/tag/v7.17.3]
1. Unpack it: `tar -zxvf elastic-7.17.3.tgz`
1. Create namespace: `kubectl create namespace metricbeat`
1. [!] Install dependency: `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`
1. `cd helm-charts-7.17.3/metricbeat/ && helm dependency build`
1. Install chart: `helm install metricbeat-release helm-charts-7.17.3/metricbeat/ --namespace metricbeat`
1. Upgrade chart: `helm upgrade metricbeat-release helm-charts-7.17.3/metricbeat/ --namespace metricbeat`

## Minio

1. Download [https://github.com/CybercentreCanada/assemblyline-helm-chart/blob/master/assemblyline/charts/minio-5.0.32.tgz]
1. Unpack it: `tar -zxvf minio-5.0.32.tgz`
1. Edit values.yaml
1. Create namespace: `kubectl create namespace minio`
1. Install: `helm install minio-release minio-helm/ --namespace minio`

## Assemblyline
- Todo

## TODO

- Add zsh
- Add kubectl auto completion
- Alias oc = kubectl
- README.md gets overwritten when running install-k3s.sh
- reenable autoscaler for `metricbeat-release-kube-state-metrics` in values.yaml: set `daemonset.enabled: true`
- Add private network IP, using nodeport atm.
- assemblyline, fix metricbeat/filebeat/datastore/log-storage-master
  - find elastic username and password
- scale up to three instances

  ## Stop or remove k3s

  To stop k3s from running: `/usr/local/bin/k3s-killall.sh`

  To delete k3s completely, run `remove-k3s.sh`