#!/bin/bash -e


echo 'instal istioctl cli tool?'; read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
curl -sL https://istio.io/downloadIstioctl | ISTIO_VERSION=1.9.1 sh -
export PATH=$PATH:$HOME/.istioctl/bin
fi

echo 'get kubernetes context?'; read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
az aks get-credentials \
    --name  EUS1DEVISTIOAKS \
    --resource-group EUS1-DEV-ISTIO-RG
fi

echo 'making sure the context is right'
kubectx EUS1DEVISTIOAKS
kubens default

echo 'install istio?'
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
istioctl install -f ./demo-profile.yaml --context EUS1DEVISTIOAKS
kubectl label namespace default istio-injection=enabled
fi

echo 'get samples?'; read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
wget https://github.com/istio/istio/archive/1.9.0.tar.gz
tar xvzf 1.9.0.tar.gz
rm 1.9.0.tar.gz
cp -r istio-1.9.0/samples .
fi


echo 'intsall bookinfo?'; read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml
fi

# echo 'ready to insall addons?'; read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
kubectl apply -f samples/addons/grafana.yaml
kubectl apply -f samples/addons/jaeger.yaml
kubectl apply -f samples/addons/kiali.yaml
kubectl apply -f samples/addons/prometheus.yaml
fi


# kubectl rollout status deployment/kiali -n istio-system
# istioctl dashboard kiali &
# echo 'ready to create traffic?'
# read
# export ingress_ip=$(kubectl get svc istio-ingressgateway -n istio-system \
#   -o jsonpath='{.status.loadBalancer.ingress[0].ip}'; echo)
# echo "sending 500 requests to http://$ingress_ip/productpage"
# for i in {1..500}; do curl -s -o /dev/null http://$ingress_ip/productpage; done
# echo 'done!'

# echo 'grafana?'
# read
# kubectl rollout status deployment/grafana -n istio-system
# istioctl dashboard grafana &

# echo 'jaeger?'
# read
# kubectl rollout status deployment/jaeger -n istio-system
# istioctl dashboard jaeger &


# echo 'zipkin?'
# read
# kubectl rollout status deployment/zipkin -n istio-system
# istioctl dashboard zipkin &
