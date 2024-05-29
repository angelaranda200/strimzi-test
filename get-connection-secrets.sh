rm -rf resources
mkdir resources

export KAFKA_CLUSTER_NAME=c4m-kafka-cluster
export KAFKA_USER_NAME=c4m-kafka-admin

kubectl get secret ${KAFKA_CLUSTER_NAME}-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.crt}' | base64 -d > resources/ca.crt
kubectl get secrets/${KAFKA_CLUSTER_NAME}-cluster-ca-cert -n kafka  -o jsonpath={.data.'ca\.p12'} | base64 -d > resources/truststore.p12
kubectl get secret ${KAFKA_CLUSTER_NAME}-cluster-ca-cert -n kafka -o jsonpath='{.data.ca\.password}' | base64 -d > resources/TRUSTORE_PASSWORD
kubectl get secrets/${KAFKA_USER_NAME} -n kafka -o jsonpath={.data.'user\.p12'} | base64 -d > resources/user.p12
kubectl get secrets/${KAFKA_USER_NAME} -n kafka -o jsonpath={.data.'user\.password'} | base64 -d > resources/KEYSTORE_PASSWORD
export PASSWORD=`cat resources/KEYSTORE_PASSWORD`
echo ${PASSWORD}
ls -alh resources/*
keytool -import -trustcacerts -alias root -file resources/ca.crt -keystore resources/kafka.truststore.jks -storepass $PASSWORD -noprompt
keytool -importkeystore -srckeystore resources/user.p12 -srcstoretype pkcs12 -destkeystore resources/kafka.truststore.jks -deststoretype jks