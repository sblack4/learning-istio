#!/bin/bash -e


function generate_traffic() {
export ingress_ip=$(kubectl get svc istio-ingressgateway -n istio-system \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}'; echo)
echo "sending 500 requests to http://$ingress_ip/productpage"
for i in {1..500}; do curl -s -o /dev/null http://$ingress_ip/productpage; done
echo 'done!'
}


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

echo 'ready to install addons?'; read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
kubectl apply -f samples/addons/grafana.yaml
kubectl apply -f samples/addons/jaeger.yaml
kubectl apply -f samples/addons/kiali.yaml
kubectl apply -f samples/addons/prometheus.yaml
kubectl apply -f samples/addons/extras/zipkin.yaml
fi


echo 'ready to run addons?'; read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
kubectl rollout status deployment/kiali -n istio-system
istioctl dashboard kiali &

generate_traffic

echo 'grafana?'
kubectl rollout status deployment/grafana -n istio-system
istioctl dashboard grafana &

echo 'jaeger?'
kubectl rollout status deployment/jaeger -n istio-system
istioctl dashboard jaeger &


echo 'zipkin?'
kubectl rollout status deployment/zipkin -n istio-system
istioctl dashboard zipkin &
fi


echo 'ready to run request routing demo?'; read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
echo 'check kiali at http://localhost:20001/kiali/console/graph/namespaces/'
generate_traffic
read
kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml
kubectl apply -f samples/bookinfo/networking/virtual-service-all-v1.yaml
echo "check kiali again!"
generate_traffic
read
kubectl apply -f samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml
generate_traffic
echo "now log into $ingress_ip/productpage as jason"
fi
