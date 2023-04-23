#!/bin/bash

echo "Downloading helm chart..."
link="https://github.com/elastic/helm-charts/archive/refs/tags/v7.17.3.tar.gz"
curl -L $link -o elasticsearch-helm.tar.gz

echo "Extracting helm chart..."
tar -xzf elasticsearch-helm.tar.gz

rm elasticsearch-helm.tar.gz

echo "Done!"
