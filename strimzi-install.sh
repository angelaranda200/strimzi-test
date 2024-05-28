

helm install my-strimzi-cluster-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator --namespace kafka


helm delete my-strimzi-cluster-operator --namespace kafka


helm install ingress ingress-nginx/ingress-nginx --namespace ingress --values values-ingress.yaml 



helm repo add strimzi https://strimzi.io/charts/
helm pull strimzi --untar

helm search repo strimzi

helm show values strimzi/strimzi-kafka-operator  > values-strimzi.yaml

helm install strimzi strimzi/strimzi-kafka-operator --values values-strimzi.yaml --namespace kafka
