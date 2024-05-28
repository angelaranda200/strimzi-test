# TEST tls
touch client.properties
KAFKA_PASSWORD=$(kubectl get secret my-user -n kafka -o jsonpath='{.data.password}' | base64 -d)
echo ${KAFKA_PASSWORD}
TRUSTSTORE_PASSWORD=$(kubectl get secret my-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.password}' | base64 -d)
echo ${TRUSTSTORE_PASSWORD}
echo """security.protocol=SASL_SSL
ssl.truststore.type=PKCS12
ssl.truststore.location=/tmp/scram-cluster-ca.p12
ssl.truststore.password=${TRUSTSTORE_PASSWORD}
ssl.truststore.location=/tmp/truststore.jks
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"my-user\" password=\"${KAFKA_PASSWORD}\";""" | tee client.properties

# test2 plain
touch client.properties
KAFKA_PASSWORD=$(kubectl get secret my-user -n kafka -o jsonpath='{.data.password}' | base64 -d)
echo ${KAFKA_PASSWORD}
echo """security.protocol=PLAINTEXT
ssl.truststore.location=/tmp/scram-cluster-ca.p12
ssl.truststore.password=${TRUSTSTORE_PASSWORD}
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"my-user\" password=\"${KAFKA_PASSWORD}\";""" | tee client.properties

##############
touch client.properties
TRUSTSTORE_PASSWORD=$(kubectl get secret my-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.password}' | base64 -d)
echo ${TRUSTSTORE_PASSWORD}
echo """security.protocol=SSL
ssl.truststore.password=${TRUSTSTORE_PASSWORD}
ssl.truststore.location=/tmp/truststore.jks
ssl.client.auth=none 
enable.ssl.certificate.verification=false""" | tee client.properties



# kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server my-cluster-kafka-bootstrap.kafka.svc.cluster.local:9093 --topic my-topic
kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 --rm=true --restart=Never
# kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/truststore.jks kafka-producer:/tmp/truststore.jks
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/scram-cluster-ca.p12 kafka-producer:/tmp/scram-cluster-ca.p12
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/truststore.jks kafka-producer:/tmp/truststore.jks
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/client.properties kafka-producer:/tmp/client.properties
kafka-console-producer.sh --producer.config /tmp/client.properties --bootstrap-server kafka-bootstrap.products-ms4m.com --topic my-topic


kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 --rm=true --restart=Never 
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/scram-cluster-ca.p12 kafka-consumer:/tmp/scram-cluster-ca.p12
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/client.properties kafka-consumer:/tmp/client.properties
kafka-console-consumer.sh --consumer.config /tmp/client.properties --bootstrap-server my-cluster-kafka-bootstrap:9093 --topic my-topic --from-beginning



kubectl run  kafka-client --restart='Never' --image docker.io/bitnami/kafka:3.6.1-debian-11-r1 --namespace kafka --command -- sleep infinity
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/scram-cluster-ca.p12 kafka-client:/tmp/scram-cluster-ca.p12
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/client.properties kafka-client:/tmp/client.properties
kubectl exec -n kafka --tty -i kafka-client bash
kafka-console-producer.sh \
            --producer.config /tmp/client.properties \
            --broker-list my-cluster-kafka-bootstrap:9093 \
            --topic test
         
## config
touch client.properties
TRUSTSTORE_PASSWORD=$(kubectl get secret my-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.password}' | base64 -d)
echo ${TRUSTSTORE_PASSWORD}
KEYSTORE_PASSWORD=$(kubectl get secrets/my-user -n kafka -o jsonpath={.data.'user\.password'} | base64 -d )
echo ${KEYSTORE_PASSWORD}
echo """ssl.truststore.location=/tmp/truststore.p12
ssl.truststore.password=${TRUSTSTORE_PASSWORD}
ssl.keystore.location =/tmp/user.p12
ssl.keystore.password=${KEYSTORE_PASSWORD}
ssl.key.password=${KEYSTORE_PASSWORD}
ssl.enabled.protocols=TLSv1.2
security.protocol=SSL
ssl.client.auth=none 
enable.ssl.certificate.verification=false
ssl.endpoint.identification.algorithm=
producer.ssl.endpoint.identification.algorithm=
consumer.ssl.endpoint.identification.algorithm=""" | tee client.properties

## test ingress

kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 --rm=true --restart=Never
# kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/truststore.jks kafka-producer:/tmp/truststore.jks
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/truststore.p12 kafka-producer:/tmp/truststore.p12
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/user.p12 kafka-producer:/tmp/user.p12
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/client.properties kafka-producer:/tmp/client.properties
kafka-console-producer.sh --producer.config /tmp/client.properties --bootstrap-server kafka-bootstrap.products-ms4m.com:443 --topic my-topic


kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 --rm=true --restart=Never 
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/scram-cluster-ca.p12 kafka-consumer:/tmp/scram-cluster-ca.p12
kubectl cp --namespace kafka /mnt/c/Users/Usuario/Desktop/strimzi/client.properties kafka-consumer:/tmp/client.properties
kafka-console-consumer.sh --consumer.config /tmp/client.properties --bootstrap-server kafka-bootstrap.products-ms4m.com:443 --topic my-topic --from-beginning