#!/bin/bash

echo "Creating manifests using helm template..."
cd helm-charts-7.17.3/elasticsearch
helm template -f ../helm-charts-7.17.3/elasticsearch/values.yaml ../helm-charts-7.17.3/elasticsearch/ --namespace elasticsearch > manifest.yaml
echo "Generated manifest.yaml from values.yaml file"

echo "Creating and changing to the 'base' directory..."
cd ../..
mkdir -p base
cd base

echo "Slicing the manifest file into separate files..."
kubectl-slice --template "{{.kind | lower}}.yaml" -f "../manifest.yaml" -o .

echo "Creating kustomization file..."
echo "apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
metadata:
  name: base
resources:" > kustomization.yaml
find . -type f -name '*.yaml' -not -name 'kustomization.yaml' -printf "  - %f\n" >> kustomization.yaml

echo "Done!"
