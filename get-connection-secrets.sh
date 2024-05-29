kubectl get secrets/c4m-kafka-cluster-cluster-ca-cert -n kafka  -o jsonpath={.data.'ca\.p12'} | base64 -d > resources/truststore.p12
kubectl get secret c4m-kafka-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.password}' | base64 -d > resources/TRUSTORE_PASSWORD

kubectl get secrets/c4m-kafka-admin -n kafka -o jsonpath={.data.'user\.p12'} | base64 -d > resources/user.p12
kubectl get secrets/c4m-kafka-admin -n kafka -o jsonpath={.data.'user\.password'} | base64 -d > resources/KEYSTORE_PASSWORD



