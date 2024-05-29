#!/bin/bash
#KAFKA_HELM_CHART_VERSION=1.12.2
KAFKA_NAMESPACE=kafka
echo "Install Strinzi Kafka"
kubectl create namespace ${KAFKA_NAMESPACE}
helm delete strimzi-cluster-operator --namespace ${KAFKA_NAMESPACE}
helm install strimzi-cluster-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator --namespace ${KAFKA_NAMESPACE}

kubectl delete -f ./kafka-cluster.yaml
kubectl apply -f ./kafka-cluster.yaml

cat /etc/hosts
echo "192.168.18.190 kafka-broker-0.products-ms4m.com" | sudo tee -a /etc/hosts
echo "192.168.18.190 kafka-bootstrap.products-ms4m.com" | sudo tee -a /etc/hosts
cat /etc/hosts

microk8s kubectl -n kube-system edit configmap/coredns
    hosts {
      192.168.18.190 kafka-broker-0.products-ms4m.com
      192.168.18.190 kafka-bootstrap.products-ms4m.com
      Fallthrough
    }

curl -Lvk https://kafka-bootstrap.products-ms4m.com
