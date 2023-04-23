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

## Delete k3s

To completely delete k3s, do the following:

1. Stop k3s service: `sudo systemctl stop k3s`
2. Uninstall: `sudo /usr/local/bin/k3s-uninstall.sh`
3. Remove data dir: `sudo rm -rf /var/lib/rancher/k3s/`
4. Remove binary and config file:
  
  ```bash
  sudo rm -rf /usr/local/bin/k3s /etc/systemd/system/k3s.service /etc/systemd/system/k3s.service.env
  ```
5. Remove ip tables:

  ```bash
  sudo iptables -F && sudo iptables -X && sudo iptables -t nat -F && sudo iptables -t nat -X && sudo iptables -t mangle -F && sudo iptables -t mangle -X && sudo iptables -P INPUT ACCEPT && sudo iptables -P FORWARD ACCEPT && sudo iptables -P OUTPUT ACCEPT
  ```

6. Remove systemctl settings:

  ```bash
  sudo sysctl -w net.bridge.bridge-nf-call-iptables=0 && sudo sysctl -w net.ipv4.conf.all.rp_filter=1 && sudo sysctl -w net.ipv4.conf.default.rp_filter=1
  ```

7. Remove cgroup settings

  ```
  sudo sed -i '/cgroup/d' /etc/fstab && sudo rm -rf /sys/fs/cgroup/systemd
  ```

  ## TODO

  - Add zsh
  - Add kubectl auto completion
  - Alias oc = kubectl