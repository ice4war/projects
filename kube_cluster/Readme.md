# k8s setup

## Minikube

```sh
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

## k3d

```sh
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

## kind

```sh
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.33.0/kind-linux-amd64
sudo install kind-linux-amd64 /usr/local/bin/kind && rm kind-linux-amd64
```

### Create cluster

```sh
k3d cluster create awx-cluster --servers 1 --agents 1
```

## kubectl

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
```

## Helm

```sh
curl -L -O "https://get.helm.sh/helm-v4.3.1-linux-amd64.tar.gz"
tar xf helm-v4.3.1-linux-amd64.tar.gz
sudo mv ./linux-amd64/helm /usr/local/bin
rm -r linux-amd64/
```

# CNI Setup

## Setup Cilium

```sh
helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.20.0 \
   --namespace kube-system \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes

## Clilium CLI
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
# sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
```

# Storage Class Setup

## Longhorn Storage Class

> Install open-iscsi packages inside the Minikube host
> Ensure the iscsid daemon is running (if using a VM driver)

```sh
sudo apt-get update && sudo apt-get install -y open-iscsi nfs-common
sudo systemctl enable iscsid && sudo systemctl start iscsid

# Add the Longhorn Helm repository
helm repo add longhorn https://charts.longhorn.io
helm repo update

# Install Longhorn to its dedicated namespace
helm install longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace
```

# AWX

```sh
helm repo add awx-operator https://ansible-community.github.io/awx-operator-helm/

helm repo update
helm search repo awx-operator
helm install -n awx --create-namespace ansible-awx awx-operator/awx-operator
```
