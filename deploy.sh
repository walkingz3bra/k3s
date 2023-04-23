#!/bin/bash

kubectl create namespace elasticsearch
kubectl create namespace kibana

kubectl apply -k elasticsearch/overlay/
kubectl apply -k kibana/overlay/