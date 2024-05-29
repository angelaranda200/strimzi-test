brew install ubuntu/microk8s/microk8s
microk8s install
microk8s status --wait-ready
microk8s enable community
microk8s enable dns
microk8s enable ha-cluster
microk8s enable helm
microk8s enable helm3
METALLB_CDIR_SEGMENT=192.168.18.190-192.168.18.195
microk8s enable metallb:${METALLB_CDIR_SEGMENT}
microk8s enable cert-manager

ls -alh $HOME/.microk8s/config
cat $HOME/.microk8s/config

ls -alh $HOME/.kube
mv $HOME/.kube/config $HOME/.kube/configBKP
cp $HOME/.microk8s/config $HOME/.kube

kubectl get nodes
