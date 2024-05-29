kubectl create namespace ingress
helm delete ingress --namespace ingress
helm install ingress ingress-nginx/ingress-nginx --namespace ingress --values values-ingress.yaml