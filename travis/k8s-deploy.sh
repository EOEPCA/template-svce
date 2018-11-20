#!/bin/bash

# fail fast settings from https://dougrichardson.org/2018/08/03/fail-fast-bash-scripting.html
set -euo pipefail
# Not supported in travis (xenial)
# shopt -s inherit_errexit


# Create the K8S environment
kubectl apply -f kubernetes/namespaces-rbac.yaml
# Database username and password are from Travis environment variables..for simplicity.  Travis secretes or Helm templates may be better.
kubectl create secret generic db-user-pass --from-literal=db_username=$DB_USER --from-literal=db_password=$DB_PASSWORD --namespace=eo-services
kubectl apply -f kubernetes/micro-service.yaml
kubectl apply -f kubernetes/rev-proxy.yaml

# wait for k8S and pods to start-up
sleep 60

# Various debug statements

# View cluster (kubectl) config in ~/.kube/config
kubectl config view
kubectl get nodes
kubectl get secret db-user-pass -o yaml --namespace=eo-services
kubectl get namespaces
kubectl get pods --all-namespaces
kubectl get deployments --namespace=eo-services catalogue-service-deployment
#- kubectl logs -lapp=catalogue-service --all-containers=true
kubectl logs --namespace=eo-services deployment/catalogue-service-deployment --all-containers=true
kubectl logs --namespace=eo-services deployment/frontend --all-containers=true
#- kubectl expose deployment catalogue-service-deployment --name=cat-svce2 --port=8083 --target-port=7000 --type=NodePort
#- kubectl get svc cat-svce
kubectl get service --namespace=eo-services cat-svce -o json
catSvcNodePort=$(kubectl get service --namespace=eo-services cat-svce --output=jsonpath='{.spec.ports[0].nodePort}')
revProxyNodePort=$(kubectl get svc --namespace=eo-services frontend --output=jsonpath='{.spec.ports[0].nodePort}')
kubectl describe deployment --namespace=eo-services catalogue-service-deployment
kubectl describe service --namespace=eo-services cat-svce
kubectl describe service --namespace=eo-services frontend

# Test connectivity with the services
- minikubeIP=$(minikube ip)  # local host machine's minikube VM IP
- clusterIP=$(kubectl get svc --namespace=eo-services cat-svce -o json | jq -r '.spec.clusterIP')
- echo $nodePort $minikubeIP $clusterIP
- curl http://${minikubeIP}:${revProxyNodePort}/search | jq '.'
- curl http://${minikubeIP}:${catSvcNodePort}/search | jq '.'
- curl -si http://${minikubeIP}:${revProxyNodePort}/search
- curl -si http://${minikubeIP}:${catSvcNodePort}/search
- export SEARCH_SERVICE_HOST=${minikubeIP}
- export SEARCH_SERVICE_PORT=${revProxyNodePort}
- ./gradlew integrationTest

- kubectl logs --namespace=eo-services deployment/frontend --all-containers=true
