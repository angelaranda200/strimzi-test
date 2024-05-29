## config
touch resources/client.properties
TRUSTSTORE_PASSWORD=$(kubectl get secret c4m-kafka-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.password}' | base64 -d)
echo ${TRUSTSTORE_PASSWORD}
KEYSTORE_PASSWORD=$(kubectl get secrets/c4m-kafka-admin -n kafka -o jsonpath={.data.'user\.password'} | base64 -d )
echo ${KEYSTORE_PASSWORD}
echo """ssl.truststore.location=/tmp/truststore.p12
ssl.truststore.password=${TRUSTSTORE_PASSWORD}
ssl.keystore.location =/tmp/user.p12
ssl.keystore.password=${KEYSTORE_PASSWORD}
ssl.key.password=${KEYSTORE_PASSWORD}
ssl.enabled.protocols=TLSv1.2
security.protocol=SSL
ssl.client.auth=required""" | tee resources/client.properties

## test ingress
kubectl -n kafka delete pod/kafka-producer
kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 --attach=false --restart=Never
# kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/truststore.jks kafka-producer:/tmp/truststore.jks
kubectl cp --namespace kafka $(pwd)/resources/truststore.p12 kafka-producer:/tmp/truststore.p12
kubectl cp --namespace kafka $(pwd)/resources/user.p12 kafka-producer:/tmp/user.p12
kubectl cp --namespace kafka $(pwd)/resources/client.properties kafka-producer:/tmp/client.properties
kubectl attach -n kafka kafka-producer -ti
./bin/kafka-console-producer.sh --producer.config /tmp/client.properties --bootstrap-server kafka-bootstrap.products-ms4m.com:443 --topic my-topic


kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 --rm=true --restart=Never 
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/scram-cluster-ca.p12 kafka-consumer:/tmp/scram-cluster-ca.p12
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/client.properties kafka-consumer:/tmp/client.properties
kafka-console-consumer.sh --consumer.config /tmp/client.properties --bootstrap-server kafka-bootstrap.products-ms4m.com:443 --topic my-topic --from-beginning