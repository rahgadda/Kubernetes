#!/bin/bash

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
mv /usr/local/bin/helm /usr/bin

# -- Validating Helm Installation
helm version

# -- Add Helm Repo
helm repo add stable https://charts.helm.sh/stable
helm repo list
helm repo update