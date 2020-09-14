#!/bin/bash

terraform output kube_config > ~/.kube/aksconfig
export KUBECONFIG=~/.kube/aksconfig

# init helm
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

# helm repo add
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Add required namespace
kubectl create ns httpd-deployment
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace httpd-deployment \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

## Deploy app through Kubectl

kubectl apply -f lamp-ingress.yaml - httpd-deployment
kubectl apply -f web.yaml -n httpd-deployment
kubectl apply -f mysql.yaml -n httpd-deployment



 
