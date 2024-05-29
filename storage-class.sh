sudo mkdir -p /opt/microk8s/local-path-provisioner
sudo chmod -R 777 /opt/microk8s/local-path-provisioner
ls -alh /opt/microk8s/local-path-provisioner

kubectl get storageclass
curl -o local-path-storage.yaml https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.24/deploy/local-path-storage.yaml
kubectl create -f local-path-storage.yaml
kubectl get all -n local-path-storage
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
