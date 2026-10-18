# AWX installation

## Setup & Start k8s cluster

```sh
# k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Create cluster
k3d cluster create awx-cluster --servers 1 --agents 1
```

## Add helm repo

```sh
# AWX
helm repo add awx-operator https://ansible-community.github.io/awx-operator-helm/

## "awx-operator" has been added to your repositories
helm repo update
helm search repo awx-operator
helm install -n awx --create-namespace ansible-awx awx-operator/awx-operator
```

# apply patches

> file kustomizatiom.yml

```yml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - github.com/ansible/awx-operator/config/default?ref=2.19.1

images:
  - name: quay.io/ansible/awx-operator
    newTag: 2.19.1
  - name: gcr.io/kubebuilder/kube-rbac-proxy
    newName: quay.io/brancz/kube-rbac-proxy
    newTag: v0.15.0

namespace: awx
```

> file deploy.yml

```yml
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: k3d-awx
  namespace: awx
spec:
  # Instructs the operator to automatically deploy a managed PostgreSQL database pod
  postgres_storage_class: local-path
  # Attaches to k3d's built-in Traefik ingress controller
  ingress_type: Ingress
  ingress_path: /
```

```sh
kubectl apply -k .
kubectl apply -f deploy.yml
```

# Expose Service

```sh
# port forward
kubectl port-forward -n awx svc/k3d-awx-service 8080:80

# get admin secret
kubectl get secret k3d-awx-admin-password -n awx -o jsonpath="{.data.password}" | base64 --decode; echo
```
