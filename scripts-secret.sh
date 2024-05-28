kubectl get secret my-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.crt}' | base64 -d > scram-cluster-ca.crt
kubectl get secret my-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.p12}' | base64 -d > scram-cluster-ca.p12
kubectl get secret my-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.password}' | base64 -d


kubectl get secret my-user -n kafka -o jsonpath='{.data.password}' | base64 -d
kubectl get secret my-user -n kafka -o jsonpath='{.data.sasl\.jaas\.config}' | base64 -d


kubectl get secret my-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt
keytool -import -trustcacerts -alias root -file scram-cluster-ca.crt -keystore truststore.jks -storepass Pig1SuFOMu3q -noprompt


kafka-console-producer.sh --producer.config /tmp/client.properties --bootstrap-server my-cluster-kafka-external2-bootstrap:9094 --topic my-topic

# openssl s_client -connect kafka-broker-0.products-ms4m.com:443 -servername kafka-broker-0.products-ms4m.com -showcerts
kafka-console-producer.sh --broker-list my-cluster-kafka-external2-bootstrap:9094 --producer-property security.protocol=SSL --producer-property ssl.truststore.password=iwsP0BRdqYio --producer-property ssl.truststore.location=/tmp/truststore.jks --topic my-topic


kafka-console-producer.sh --bootstrap-server my-cluster-kafka-external2-bootstrap:9094 --producer-property security.protocol=SSL --producer-property ssl.truststore.password=bmZ9pJNabBhl --producer-property ssl.truststore.location=/tmp/truststore.jks --topic my-topic



##################333
kubectl get secrets/my-cluster-cluster-ca-cert -n kafka  -o jsonpath={.data.'ca\.p12'} | base64 -d > truststore.p12
kubectl get secret my-cluster-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.password}' | base64 -d

kubectl get secrets/my-user -n kafka -o jsonpath={.data.'user\.p12'} | base64 -d > user.p12
kubectl get secrets/my-user -n kafka -o jsonpath={.data.'user\.password'} | base64 -d 



