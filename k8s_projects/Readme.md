## Setup Cluster

### k3d

```sh
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

## Create Cluster

```sh
k3d cluster create --config k3d.yml
```

## Setup Cilium CNI

```sh
helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.20.0 \
   --namespace kube-system \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes
```

## Setup LoadBalancer
```sh
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb
```
