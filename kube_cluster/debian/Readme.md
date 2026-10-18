##  VM control plane
```sh
rm -r /etc/kubernetes/ /var/lib/kubelet/ /var/lib/etcd/

rm -r $HOME/.kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
```sh
kubeadm token create --print-join-command

sudo kubeadm init --apiserver-advertise-address=192.168.56.108 --apiserver-cert-extra-sans=192.168.56.108 --pod-network-cidr=10.244.0.0/16

kubeadm join 192.168.56.108:6443 --token h57jda.8hhuc8xs9f7u2hml \
	--discovery-token-ca-cert-hash sha256:645e39466ab1273e6712310d2d561b4253410c96e76256f55a7821842406d3e5

kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/refs/heads/master/manifests/calico.yaml
```
