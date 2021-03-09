#!/bin/bash


echo 'installing istioctl cli tool'
curl -sL https://istio.io/downloadIstioctl | ISTIO_VERSION=1.9.1 sh -
export PATH=$PATH:$HOME/.istioctl/bin

echo 'getting kubernetes context'
az aks get-credentials \
    --name  EUS1DEVISTIOAKS \
    --resource-group EUS1-DEV-ISTIO-RG

echo 'installling istio'
istioctl install -f demo-profile.yml --context EUS1DEVISTIOAKS
