## config
touch resources/client.properties
export KEYSTORE_PASSWORD=`cat resources/KEYSTORE_PASSWORD`
echo """bootstrap-server=kafka-bootstrap.products-ms4m.com:443
ssl.enabled.protocols=TLSv1.2
security.protocol=SSL
ssl.keystore.location =/tmp/user.p12
ssl.keystore.password=${KEYSTORE_PASSWORD}
ssl.key.password=${KEYSTORE_PASSWORD}
ssl.truststore.location=/tmp/kafka.truststore.jks
ssl.truststore.password=${KEYSTORE_PASSWORD}""" | tee resources/client.properties

## test ingress
kubectl -n kafka delete pod/kafka-producer
kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 --attach=false --restart=Never
kubectl cp --namespace kafka $(pwd)/resources/kafka.truststore.jks kafka-producer:/tmp/kafka.truststore.jks
kubectl cp --namespace kafka $(pwd)/resources/user.p12 kafka-producer:/tmp/user.p12
kubectl cp --namespace kafka $(pwd)/resources/truststore.p12 kafka-producer:/tmp/truststore.p12
kubectl cp --namespace kafka $(pwd)/resources/client.properties kafka-producer:/tmp/client.properties
kubectl attach -n kafka kafka-producer -ti
./bin/kafka-console-producer.sh --producer.config /tmp/client.properties --bootstrap-server kafka-bootstrap.products-ms4m.com:443 --topic my-topic

./bin/kafka-console-producer.sh --broker-list kafka-bootstrap.products-ms4m.com:443 --producer-property security.protocol=SSL --producer-property ssl.truststore.password=RVM3M5lbmhbJh5EKZETvb3xDkNkcf0UB --producer-property ssl.truststore.location=/tmp/kafka.truststore.jks --topic my-topic

openssl pkcs12 -info -in $(pwd)/resources/user.p12

./bin/kafka-console-producer.sh --broker-list kafka-bootstrap.products-ms4m.com:443 \
                                --producer-property security.protocol=SSL \
                                --producer-property ssl.truststore.location=/tmp/kafka.truststore.jks \
                                --producer-property ssl.truststore.password=RVM3M5lbmhbJh5EKZETvb3xDkNkcf0UB \
                                --topic my-topic

./bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-ssl-topic