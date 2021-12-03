#!/bin/bash

# go to working directory folder
cd ../terraform/prometheus_grafana

# Create monitoring namespace
kubectl create namespace monitoring

#######################################
### deploy prometheus
#######################################
# Create ClusterRole
kubectl create -f clusterRole.yaml
# Create the Config Map
kubectl create -f config-map.yaml
# Create a deployment on monitoring namespace
kubectl create  -f prometheus-deployment.yaml 
# Create the service
kubectl create -f prometheus-service.yaml --namespace=monitoring

#######################################
### deploy grafana
#######################################
kubectl create -f grafana-datasource-config.yaml
# Create the deployment 
kubectl create -f deployment.yaml
# Create the service
kubectl create -f service.yaml
