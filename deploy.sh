#!/bin/bash

kubectl create namespace elasticsearch
kubectl create namespace kibana
kubectl create namespace filebeat
kubectl create namespace minio

kubectl apply -k elasticsearch/overlay/
kubectl apply -k kibana/overlay/
kubectl apply -k filebeat/overlay/
kubectl apply -k metricbeat/overlay/
kubectl apply -k minio/overlay/
